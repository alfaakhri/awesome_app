import 'package:awesome_app/features/photo_list/data/models/photo_model.dart';
import 'package:awesome_app/features/photo_list/domain/repository/photo_repository.dart';
import 'package:awesome_app/features/photo_list/presentation/managers/photo_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoRepository extends Mock implements PhotoRepository {}

void main() {
  late MockPhotoRepository mockPhotoRepository;
  late PhotoBloc photoBloc;

  setUp(() {
    mockPhotoRepository = MockPhotoRepository();
    photoBloc = PhotoBloc(photoRepository: mockPhotoRepository);
  });

  group('PhotoBloc', () {
    var testPhotoModel = PhotoModel(
      id: 1,
      width: 200,
      height: 300,
      url: 'https://example.com/photo.jpg',
      photographer: 'John Doe',
      photographerUrl: 'https://example.com/photographer',
      photographerId: 123,
      avgColor: '#000000',
      src: Src(
        original: 'https://example.com/photo-original.jpg',
        large2X: 'https://example.com/photo-large2x.jpg',
        large: 'https://example.com/photo-large.jpg',
        medium: 'https://example.com/photo-medium.jpg',
        small: 'https://example.com/photo-small.jpg',
        portrait: 'https://example.com/photo-portrait.jpg',
        landscape: 'https://example.com/photo-landscape.jpg',
        tiny: 'https://example.com/photo-tiny.jpg',
      ),
      liked: true,
      alt: 'An example photo',
    );

    test('initial state is PhotoInitial', () {
      expect(photoBloc.state, equals(const PhotoState.initial()));
    });

    blocTest<PhotoBloc, PhotoState>(
      'emits [PhotoLoading, PhotoLoaded] when PhotoRepository fetches photos successfully',
      build: () {
        when(() => mockPhotoRepository.getPhotos('food', 1)).thenAnswer(
          (_) async => [testPhotoModel],
        );
        return photoBloc;
      },
      act: (bloc) {
        bloc.add(const PhotoEvent.loadPhotosByCategory(category: 'food', page: 1));
      },
      expect: () => [
        const PhotoState.loading(),
        PhotoState.loaded(photos: [testPhotoModel], hasReachedMax: true),
      ],
      verify: (_) {
        verify(() => mockPhotoRepository.getPhotos('food', 1)).called(1);
      },
    );

    blocTest<PhotoBloc, PhotoState>(
      'emits [PhotoLoading, PhotoError] when PhotoRepository fails to fetch photos',
      build: () {
        when(() => mockPhotoRepository.getPhotos('food', 1)).thenThrow(Exception('Failed to fetch photos'));
        return photoBloc;
      },
      act: (bloc) => bloc.add(const PhotoEvent.loadPhotosByCategory(category: 'food', page: 1)),
      expect: () => [
        const PhotoState.loading(),
        PhotoState.error(Exception('Failed to fetch photos').toString()),
      ],
      verify: (_) {
        verify(() => mockPhotoRepository.getPhotos('food', 1)).called(1);
      },
    );
  });

  tearDown(() {
    photoBloc.close();
  });
}
