part of 'photo_detail_bloc.dart';

@freezed
class PhotoDetailState with _$PhotoDetailState {
  /// State awal
  const factory PhotoDetailState.initial() = _Initial;

  /// State saat sedang loading data
  const factory PhotoDetailState.loading() = _Loading;

  /// State saat data berhasil dimuat
  const factory PhotoDetailState.loaded({
    required PhotoDetailModel photos,
  }) = _Loaded;

  /// State saat terjadi error
  const factory PhotoDetailState.error(String message) = _Error;
}
