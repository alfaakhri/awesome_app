import '../../../../core/api_clients.dart';
import '../models/photo_model.dart';

class PhotoService {
  final ApiClient apiClient;

  PhotoService({required this.apiClient});

  Future<List<PhotoModel>> fetchPhotos(String category, int page) async {
    try {
      final data =
          await apiClient.get('/search', queryParameters: {'query': category, 'page': '$page', 'per_page': '10'});
      final List photosData = data['photos'];

      return photosData.map((json) => PhotoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load photos: $e');
    }
  }
}
