import '../../../../core/api_clients.dart';
import '../models/photo_detail_model.dart';

class PhotoDetailService {
  final ApiClient apiClient;

  PhotoDetailService({required this.apiClient});

  Future<PhotoDetailModel> fetchDetailPhotos(int photoId) async {
    try {
      final data = await apiClient.get('/photos/$photoId');

      return PhotoDetailModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load photos: $e');
    }
  }
}
