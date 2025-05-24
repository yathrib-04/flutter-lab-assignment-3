import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import '../bloc/album_bloc.dart';
import '../views/OnboardingScreen.dart';
import '../views/album_detail_screen.dart';
import '../views/album_list_screen.dart';

GoRouter createRouter(AlbumBloc albumBloc) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Navigation error: Route not found')),
    ),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/albums',
        builder: (context, state) => BlocProvider.value(
          value: albumBloc,
          child: const AlbumListScreen(),
        ),
      ),
      GoRoute(
        path: '/album/:id',
        builder: (context, state) {
          final albumId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          if (albumId <= 0) {
            return const Scaffold(
              body: Center(child: Text('Invalid album ID')),
            );
          }
          return BlocProvider.value(
            value: albumBloc,
            child: AlbumDetailScreen(albumId: albumId),
          );
        },
      ),
    ],
  );
}