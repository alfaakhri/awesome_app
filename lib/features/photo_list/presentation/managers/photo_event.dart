import 'package:equatable/equatable.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk memuat foto pertama kali
class LoadPhotos extends PhotoEvent {
  final int page;

  const LoadPhotos(this.page);

  @override
  List<Object?> get props => [page];
}

// Event untuk memuat lebih banyak foto (infinite scroll)
class LoadMorePhotos extends PhotoEvent {
  final int page;

  const LoadMorePhotos(this.page);

  @override
  List<Object?> get props => [page];
}
