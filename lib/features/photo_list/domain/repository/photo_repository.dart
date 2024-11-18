import '../../data/models/photo_model.dart';
import '../../data/services/photo_service.dart';

class PhotoRepository {
  final PhotoService photoService;

  // Constructor menerima PhotoService sebagai parameter
  PhotoRepository({required this.photoService});

  // Metode untuk fetch data foto dari PhotoService
  Future<List<PhotoModel>> getPhotos(String category, int page) async {
    try {
      // Mengambil data dari PhotoService
      return await photoService.fetchPhotos(category, page);
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }
}
