import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/photo_model.dart';
import '../../domain/repository/photo_repository.dart';
import 'photo_event.dart';
import 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository photoRepository;

  PhotoBloc(this.photoRepository) : super(PhotoInitial()) {
    on<LoadPhotos>(_onLoadPhotos);
    on<LoadMorePhotos>(_onLoadMorePhotos);
  }

  Future<void> _onLoadPhotos(LoadPhotos event, Emitter<PhotoState> emit) async {
    emit(PhotoLoading());
    try {
      final photos = await photoRepository.getPhotos(event.page);
      emit(PhotoLoaded(photos: photos));
    } catch (e) {
      emit(PhotoError('Failed to load photos: $e'));
    }
  }

  Future<void> _onLoadMorePhotos(LoadMorePhotos event, Emitter<PhotoState> emit) async {
    if (state is PhotoLoaded) {
      final currentState = state as PhotoLoaded;

      if (currentState.hasReachedMax) return;

      try {
        final photos = await photoRepository.getPhotos(event.page);
        final allPhotos = List<PhotoModel>.from(currentState.photos)..addAll(photos);
        emit(PhotoLoaded(photos: allPhotos, hasReachedMax: photos.isEmpty));
      } catch (e) {
        emit(PhotoError('Failed to load more photos: $e'));
      }
    }
  }
}
