import 'package:equatable/equatable.dart';

import '../../data/models/photo_model.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object?> get props => [];
}

// State awal (belum ada data)
class PhotoInitial extends PhotoState {}

// State ketika data sedang dimuat
class PhotoLoading extends PhotoState {}

// State ketika data berhasil dimuat
class PhotoLoaded extends PhotoState {
  final List<PhotoModel> photos;
  final bool hasReachedMax;

  const PhotoLoaded({required this.photos, this.hasReachedMax = false});

  @override
  List<Object?> get props => [photos, hasReachedMax];
}

// State ketika terjadi error
class PhotoError extends PhotoState {
  final String message;

  const PhotoError(this.message);

  @override
  List<Object?> get props => [message];
}
