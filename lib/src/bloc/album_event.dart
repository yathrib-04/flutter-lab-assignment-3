import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class FetchAlbums extends AlbumEvent {
  const FetchAlbums();
}

class FetchPhotos extends AlbumEvent {
  final int albumId;

  const FetchPhotos(this.albumId);

  @override
  List<Object> get props => [albumId];
}