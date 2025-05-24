import '../models/album.dart';
import '../models/photo.dart';
import '../services/api_service.dart';

class AlbumRepository {
  final ApiService _apiService;

  AlbumRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Album>> getAlbums() async {
    try {
      return await _apiService.fetchAlbums();
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Photo>> getPhotos(int albumId) async {
    try {
      return await _apiService.fetchPhotos(albumId);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}