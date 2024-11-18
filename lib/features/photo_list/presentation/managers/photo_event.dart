part of 'photo_bloc.dart';

@freezed
class PhotoEvent with _$PhotoEvent {
  /// Event untuk memuat foto berdasarkan kategori (halaman pertama)
  const factory PhotoEvent.loadPhotosByCategory({
    required String category,
    required int page,
  }) = _LoadPhotosByCategory;

  /// Event untuk memuat lebih banyak foto berdasarkan kategori (infinite scroll)
  const factory PhotoEvent.loadMorePhotosByCategory({
    required String category,
    required int page,
  }) = _LoadMorePhotosByCategory;

  const factory PhotoEvent.loadPhotosFromLocal({
    required String category,
  }) = _LoadPhotosFromLocal;
}
