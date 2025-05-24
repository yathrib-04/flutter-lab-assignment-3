import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album/src/view_models/album_view_model.dart';
import '../repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';



class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;
  List<AlbumViewModel> _albums = [];

  AlbumBloc({required this.albumRepository}) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchPhotos>(_onFetchPhotos);
    add(const FetchAlbums());
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.getAlbums();
      _albums = albums.map((album) => AlbumViewModel(album: album)).toList();
      emit(AlbumLoaded(_albums));
    } catch (e) {
      emit(AlbumError('Failed to load albums: $e'));
    }
  }

  Future<void> _onFetchPhotos(FetchPhotos event, Emitter<AlbumState> emit) async {
    try {
      if (_albums.isEmpty) {
        final albums = await albumRepository.getAlbums();
        _albums = albums.map((album) => AlbumViewModel(album: album)).toList();
        emit(AlbumLoaded(_albums));
      }
      final albumViewModel = _albums.firstWhere(
            (vm) => vm.id == event.albumId,
        orElse: () => AlbumViewModel(album: null),
      );
      if (albumViewModel.album == null) {
        throw Exception('Album not found for ID: ${event.albumId}');
      }
      if (albumViewModel.photos.isNotEmpty) {
        emit(PhotosLoaded(albumViewModel, _albums));
        return;
      }
      final photos = await albumRepository.getPhotos(event.albumId);
      final updatedViewModel = AlbumViewModel(album: albumViewModel.album, photos: photos);
      final index = _albums.indexWhere((vm) => vm.id == event.albumId);
      if (index != -1) {
        _albums[index] = updatedViewModel;
      }
      emit(PhotosLoaded(updatedViewModel, _albums));
    } catch (e) {
      emit(AlbumError('Failed to load photos: $e'));
    }
  }
}

