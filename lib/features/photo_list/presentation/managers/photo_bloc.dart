import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/photo_model.dart';
import '../../domain/repository/photo_repository.dart';

part 'photo_bloc.freezed.dart';
part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository _photoRepository;

  PhotoBloc({PhotoRepository? photoRepository})
      : _photoRepository = photoRepository ?? PhotoRepository(),
        super(const PhotoState.initial()) {
    on<_LoadPhotosByCategory>((event, emit) async {
      try {
        emit(const PhotoState.loading());
        final photos = await _photoRepository.getPhotos(
          event.category,
          event.page,
        );
        emit(PhotoState.loaded(photos: photos, hasReachedMax: photos.length < 10));
      } catch (e) {
        emit(PhotoState.error(e.toString()));
      }
    });
    on<_LoadMorePhotosByCategory>((event, emit) async {
      final currentState = state;
      if (currentState is _Loaded && !currentState.hasReachedMax) {
        try {
          final photos = await _photoRepository.getPhotos(
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
  }
}
