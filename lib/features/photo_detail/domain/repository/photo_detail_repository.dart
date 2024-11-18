import '../../data/models/photo_detail_model.dart';
import '../../data/services/photo_detail_service.dart';

class PhotoDetailRepository {
  final PhotoDetailService photoService;

  // Constructor menerima PhotoService sebagai parameter
  PhotoDetailRepository({required this.photoService});

  // Metode untuk fetch data foto dari PhotoDetailService
  Future<PhotoDetailModel> getPhotos(int photoId) async {
    try {
      // Mengambil data dari PhotoService
      return await photoService.fetchDetailPhotos(photoId);
    } catch (e) {
      throw Exception('Failed to fetch detail photos: $e');
    }
  }
}
