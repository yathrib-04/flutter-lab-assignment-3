import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/album_bloc.dart';
import '../bloc/album_event.dart';
import '../bloc/album_state.dart';
import '../view_models/album_view_model.dart';


class AlbumDetailScreen extends StatelessWidget {
  final int albumId;

  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Details'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumInitial || state is AlbumLoading) {
            context.read<AlbumBloc>().add(FetchPhotos(albumId));
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded || state is PhotosLoaded) {
            final albumViewModel = (state is AlbumLoaded)
                ? state.albums.firstWhere(
                  (vm) => vm.id == albumId,
              orElse: () {
                context.read<AlbumBloc>().add(FetchPhotos(albumId));
                return AlbumViewModel(album: null);
              },
            )
                : (state as PhotosLoaded).albumViewModel.id == albumId
                ? (state).albumViewModel
                : state.albums.firstWhere(
                  (vm) => vm.id == albumId,
              orElse: () {
                context.read<AlbumBloc>().add(FetchPhotos(albumId));
                return AlbumViewModel(album: null);
              },
            );
            if (albumViewModel.album == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title: ${albumViewModel.title}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Album ID: ${albumViewModel.id}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'User ID: ${albumViewModel.userId}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: albumViewModel.photos.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: albumViewModel.photos.length,
                    itemBuilder: (context, index) {
                      final photo = albumViewModel.photos[index];
                      return Column(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: photo.thumbnailUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ),
                          ),
                          Text(
                            photo.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AlbumBloc>().add(FetchPhotos(albumId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}