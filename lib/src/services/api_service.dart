import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/photo.dart';


class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/albums'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Photo>> fetchPhotos(int albumId) async {
    final response = await http.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}