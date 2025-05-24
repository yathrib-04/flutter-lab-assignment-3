import 'package:album/src/view_models/album_view_model.dart';

abstract class AlbumState {}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<AlbumViewModel> albums;

  AlbumLoaded(this.albums);
}

class PhotosLoaded extends AlbumState {
  final AlbumViewModel albumViewModel;
  final List<AlbumViewModel> albums;

  PhotosLoaded(this.albumViewModel, this.albums);
}

class AlbumError extends AlbumState {
  final String message;

  AlbumError(this.message);
}