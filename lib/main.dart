import 'package:album/src/repositories/album_repository.dart';
import 'package:album/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album/src/bloc/album_bloc.dart';
import 'package:album/src/routes/app_routes.dart';


void main() {
  final apiService = ApiService();
  final albumRepository = AlbumRepository(apiService: apiService);
  runApp(MyApp(albumRepository: albumRepository));
}

class MyApp extends StatelessWidget {
  final AlbumRepository albumRepository;

  const MyApp({super.key, required this.albumRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumBloc(albumRepository: albumRepository),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Album App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              cardTheme: const CardThemeData(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            routerConfig: createRouter(context.read<AlbumBloc>()),
          );
        },
      ),
    );
  }
}
