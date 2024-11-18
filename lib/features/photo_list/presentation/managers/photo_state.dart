part of 'photo_bloc.dart';

@freezed
class PhotoState with _$PhotoState {
  /// State awal
  const factory PhotoState.initial() = _Initial;

  /// State saat sedang loading data
  const factory PhotoState.loading() = _Loading;

  /// State saat data berhasil dimuat
  const factory PhotoState.loaded({
    required List<PhotoModel> photos,
    required bool hasReachedMax,
  }) = _Loaded;

  /// State saat terjadi error
  const factory PhotoState.error(String message) = _Error;
}
