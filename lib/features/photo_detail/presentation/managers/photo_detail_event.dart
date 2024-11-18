part of 'photo_detail_bloc.dart';

@freezed
class PhotoDetailEvent with _$PhotoDetailEvent {
  const factory PhotoDetailEvent.getPhotoById({
    required int photoId,
  }) = _GetPhotoById;
}
