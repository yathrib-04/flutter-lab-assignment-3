import 'package:album/src/models/album.dart';
import 'package:album/src/models/photo.dart';

class AlbumViewModel {
  final Album? album;
  final List<Photo> photos;

  AlbumViewModel({this.album, this.photos = const []});

  int get id => album?.id ?? 0;
  int get userId => album?.userId ?? 0;
  String get title => album?.title ?? 'No title';
}