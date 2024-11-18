import 'package:awesome_app/features/home/managers/show_item_bloc.dart';
import 'package:awesome_app/features/photo_list/data/models/photo_model.dart';
import 'package:awesome_app/features/photo_list/presentation/managers/photo_bloc.dart';
import 'package:awesome_app/features/photo_list/presentation/pages/photo_list_page.dart';
import 'package:awesome_app/features/photo_list/presentation/widgets/photo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoBloc extends Mock implements PhotoBloc {}

class MockShowItemBloc extends Mock implements ShowItemBloc {}

void main() {
  late MockPhotoBloc mockPhotoBloc;
  late MockShowItemBloc mockShowItemBloc;

  setUp(() {
    mockPhotoBloc = MockPhotoBloc();
    mockShowItemBloc = MockShowItemBloc();
  });

  Widget createTestableWidget(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotoBloc>.value(value: mockPhotoBloc),
        BlocProvider<ShowItemBloc>.value(value: mockShowItemBloc),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('Displays loading indicator when state is loading', (WidgetTester tester) async {
    // Arrange: Mock state as loading
    when(() => mockPhotoBloc.state).thenReturn(const PhotoState.loading());
    when(() => mockShowItemBloc.state).thenReturn(const ShowItemState.show(isGrid: true));

    // Act
    await tester.pumpWidget(createTestableWidget(const PhotoListPage(category: 'Nature')));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays error message when state is error', (WidgetTester tester) async {
    // Arrange: Mock state as error
    when(() => mockPhotoBloc.state).thenReturn(const PhotoState.error('Error loading photos.'));
    when(() => mockShowItemBloc.state).thenReturn(const ShowItemState.show(isGrid: true));

    // Act
    await tester.pumpWidget(createTestableWidget(const PhotoListPage(category: 'Nature')));

    // Assert
    expect(find.text('Error loading photos.'), findsOneWidget);
  });

  testWidgets('Displays photos in grid view when state is loaded', (WidgetTester tester) async {
    // Arrange: Mock state as loaded with photos
    final mockPhotos = [
      PhotoModel(
        id: 1,
        width: 200,
        height: 300,
        url: 'https://example.com/photo1.jpg',
        photographer: 'Alice',
        photographerUrl: 'https://example.com/photographer/alice',
        photographerId: 101,
        avgColor: '#FF5733',
        src: Src(
          original: 'https://example.com/photo-original1.jpg',
          large2X: 'https://example.com/photo-large2x1.jpg',
          large: 'https://example.com/photo-large1.jpg',
          medium: 'https://example.com/photo-medium1.jpg',
          small: 'https://example.com/photo-small1.jpg',
          portrait: 'https://example.com/photo-portrait1.jpg',
          landscape: 'https://example.com/photo-landscape1.jpg',
          tiny: 'https://example.com/photo-tiny1.jpg',
        ),
        liked: true,
        alt: 'Beautiful sunset',
      ),
    ];

    when(() => mockPhotoBloc.state).thenReturn(PhotoState.loaded(photos: mockPhotos, hasReachedMax: true));
    when(() => mockShowItemBloc.state).thenReturn(const ShowItemState.show(isGrid: true));

    // Act
    await tester.pumpWidget(createTestableWidget(const PhotoListPage(category: 'Nature')));

    // Assert
    expect(find.byType(PhotoItem), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
  });

  testWidgets('Triggers scroll listener when reaching end of list', (WidgetTester tester) async {
    // Arrange: Mock state as loaded
    final mockPhotos = List.generate(
      20,
      (index) => PhotoModel(
        id: index,
        width: 200,
        height: 300,
        url: 'https://example.com/photo$index.jpg',
        photographer: 'Photographer $index',
        photographerUrl: 'https://example.com/photographer/$index',
        photographerId: index,
        avgColor: '#FF5733',
        src: Src(
          original: 'https://example.com/photo-original$index.jpg',
          large2X: 'https://example.com/photo-large2x$index.jpg',
          large: 'https://example.com/photo-large$index.jpg',
          medium: 'https://example.com/photo-medium$index.jpg',
          small: 'https://example.com/photo-small$index.jpg',
          portrait: 'https://example.com/photo-portrait$index.jpg',
          landscape: 'https://example.com/photo-landscape$index.jpg',
          tiny: 'https://example.com/photo-tiny$index.jpg',
        ),
        liked: true,
        alt: 'Photo $index',
      ),
    );

    when(() => mockPhotoBloc.state).thenReturn(PhotoState.loaded(photos: mockPhotos, hasReachedMax: false));
    when(() => mockShowItemBloc.state).thenReturn(const ShowItemState.show(isGrid: true));

    // Act
    await tester.pumpWidget(createTestableWidget(const PhotoListPage(category: 'Nature')));
    await tester.drag(find.byType(GridView), const Offset(0, -500)); // Simulate scroll
    await tester.pumpAndSettle();

    // Assert
    verify(() => mockPhotoBloc.add(any())).called(1); // Verify load more photos called
  });
}
