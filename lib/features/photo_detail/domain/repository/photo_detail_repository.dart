import 'package:awesome_app/core/api_clients.dart';

import '../../data/models/photo_detail_model.dart';
import '../../data/services/photo_detail_service.dart';

class PhotoDetailRepository {
  final PhotoDetailService _photoService;

  // Constructor menerima PhotoService sebagai parameter
  PhotoDetailRepository({PhotoDetailService? photoService})
      : _photoService = photoService ?? PhotoDetailService(apiClient: ApiClient.instance);

  // Metode untuk fetch data foto dari PhotoDetailService
  Future<PhotoDetailModel> getPhotos(int photoId) async {
    try {
      // Mengambil data dari PhotoService
      return await _photoService.fetchDetailPhotos(photoId);
    } catch (e) {
      throw Exception('Failed to fetch detail photos: $e');
    }
  }
}
