import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/album_bloc.dart';
import '../bloc/album_event.dart';
import '../bloc/album_state.dart';
import '../widgets/album_list_item.dart';


class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              context.go('/');
            },
            tooltip: 'Go to Onboarding',
          ),
        ],
      ),
      body: BlocConsumer<AlbumBloc, AlbumState>(
        listener: (context, state) {
          if (state is AlbumInitial) {
            context.read<AlbumBloc>().add(const FetchAlbums());
          }
        },
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded || state is PhotosLoaded) {
            final albums = (state is AlbumLoaded) ? state.albums : (state as PhotosLoaded).albums;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                if (album.photos.isEmpty && index < 30) {
                  context.read<AlbumBloc>().add(FetchPhotos(album.id));
                }
                return AlbumListItem(album: album);
              },
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
                      context.read<AlbumBloc>().add(const FetchAlbums());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Loading albums...'));
        },
      ),
    );
  }
}