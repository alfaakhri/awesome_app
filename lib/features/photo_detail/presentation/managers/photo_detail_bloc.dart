import 'package:awesome_app/features/photo_detail/data/models/photo_detail_model.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/repository/photo_detail_repository.dart';

part 'photo_detail_bloc.freezed.dart';
part 'photo_detail_event.dart';
part 'photo_detail_state.dart';

class PhotoDetailBloc extends Bloc<PhotoDetailEvent, PhotoDetailState> {
  final PhotoDetailRepository _photoDetailRepository;
  PhotoDetailBloc({PhotoDetailRepository? photoDetailRepository})
      : _photoDetailRepository = photoDetailRepository ?? PhotoDetailRepository(),
        super(const PhotoDetailState.initial()) {
    on<_GetPhotoById>((event, emit) async {
      try {
        emit(const PhotoDetailState.loading());
        final photos = await _photoDetailRepository.getPhotos(
          event.photoId,
        );
        emit(PhotoDetailState.loaded(photos: photos));
      } catch (e) {
        emit(PhotoDetailState.error(e.toString()));
      }
    });
  }
}
