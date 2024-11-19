import 'package:awesome_app/features/photo_detail/data/models/photo_detail_model.dart';
import 'package:awesome_app/features/photo_detail/domain/repository/photo_detail_repository.dart';
import 'package:awesome_app/features/photo_detail/presentation/managers/photo_detail_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoDetailRepository extends Mock implements PhotoDetailRepository {}

void main() {
  late MockPhotoDetailRepository mockPhotoDetailRepository;
  late PhotoDetailBloc photoDetailBloc;

  setUp(() {
    mockPhotoDetailRepository = MockPhotoDetailRepository();
    photoDetailBloc = PhotoDetailBloc(photoDetailRepository: mockPhotoDetailRepository);
  });

  group('PhotoDetailBloc', () {
    final testPhotoDetailModel = PhotoDetailModel(
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

    test('initial state is PhotoDetailInitial', () {
      expect(photoDetailBloc.state, equals(const PhotoDetailState.initial()));
    });

    blocTest<PhotoDetailBloc, PhotoDetailState>(
      'emits [PhotoDetailLoading, PhotoDetailLoaded] when PhotoDetailRepository fetches photo successfully',
      build: () {
        when(() => mockPhotoDetailRepository.getPhotos(1)).thenAnswer((_) async => testPhotoDetailModel);
        return photoDetailBloc;
      },
      act: (bloc) => bloc.add(const PhotoDetailEvent.getPhotoById(photoId: 1)),
      expect: () => [
        const PhotoDetailState.loading(),
        PhotoDetailState.loaded(photos: testPhotoDetailModel),
      ],
      verify: (_) {
        verify(() => mockPhotoDetailRepository.getPhotos(1)).called(1);
      },
    );

    blocTest<PhotoDetailBloc, PhotoDetailState>(
      'emits [PhotoDetailLoading, PhotoDetailError] when PhotoDetailRepository fails to fetch photo',
      build: () {
        when(() => mockPhotoDetailRepository.getPhotos(1)).thenThrow(Exception('Failed to fetch photo'));
        return photoDetailBloc;
      },
      act: (bloc) => bloc.add(const PhotoDetailEvent.getPhotoById(photoId: 1)),
      expect: () => [
        const PhotoDetailState.loading(),
        PhotoDetailState.error(Exception('Failed to fetch photo').toString()),
      ],
      verify: (_) {
        verify(() => mockPhotoDetailRepository.getPhotos(1)).called(1);
      },
    );
  });

  tearDown(() {
    photoDetailBloc.close();
  });
}
