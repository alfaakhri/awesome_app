import 'package:awesome_app/core/api_clients.dart';

import '../../data/models/photo_model.dart';
import '../../data/services/photo_service.dart';

class PhotoRepository {
  final PhotoService _photoService;

  // Constructor menerima PhotoService sebagai parameter
  PhotoRepository({PhotoService? photoService})
      : _photoService = photoService ?? PhotoService(apiClient: ApiClient.instance);

  // Metode untuk fetch data foto dari PhotoService
  Future<List<PhotoModel>> getPhotos(String category, int page) async {
    try {
      // Mengambil data dari PhotoService
      return await _photoService.fetchPhotos(category, page);
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }
}
