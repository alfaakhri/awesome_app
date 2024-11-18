import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../data/models/photo_model.dart';
import '../../domain/repository/photo_repository.dart';

part 'photo_bloc.freezed.dart';
part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository photoRepository;

  PhotoBloc(this.photoRepository) : super(const PhotoState.initial()) {
    on<_LoadPhotosByCategory>((event, emit) async {
      try {
        emit(const PhotoState.loading());
        final photos = await photoRepository.getPhotos(event.category, event.page);

        // Simpan data ke Hive setelah mengambil dari API
        final photoBox = await Hive.openBox<List<PhotoModel>>('list_photos');
        await photoBox.put(event.category, photos);

        emit(PhotoState.loaded(photos: photos, hasReachedMax: photos.length < 10));
      } catch (e) {
        emit(PhotoState.error(e.toString()));
      }
    });
    on<_LoadMorePhotosByCategory>((event, emit) async {
      final currentState = state;
      if (currentState is _Loaded && !currentState.hasReachedMax) {
        try {
          final photos = await photoRepository.getPhotos(
            event.category,
            event.page,
          );
          emit(PhotoState.loaded(
            photos: currentState.photos + photos,
            hasReachedMax: photos.isEmpty,
          ));
        } catch (e) {
          emit(PhotoState.error(e.toString()));
        }
      }
    });
    // Event untuk mengambil data dari Hive
    on<_LoadPhotosFromLocal>((event, emit) async {
      try {
        dynamic photoBox;
        if (Hive.isBoxOpen('list_photos')) {
          photoBox = Hive.box('list_photos');
        } else {
          photoBox = await Hive.openBox<List<dynamic>>('list_photos');
        }
        final cachedPhotos = photoBox.get(event.category);

        if (cachedPhotos != null) {
          // Mengonversi List<dynamic> ke List<PhotoModel>
          final photos = cachedPhotos.cast<PhotoModel>();

          emit(PhotoState.loaded(photos: photos, hasReachedMax: false));
        } else {
          emit(const PhotoState.error("No local data found."));
        }
      } catch (e) {
        emit(PhotoState.error(e.toString()));
      }
    });
  }
}
