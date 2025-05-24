import 'package:album/src/%20repositories/album_repository.dart';
import 'package:album/src/bloc/album_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:album/main.dart';
import 'package:album/src/bloc/album_bloc.dart';
import 'package:album/src/models/album.dart';
import 'package:album/src/models/photo.dart';


class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late MockAlbumRepository mockAlbumRepository;
  late AlbumBloc albumBloc;

  setUp(() {
    mockAlbumRepository = MockAlbumRepository();
    albumBloc = AlbumBloc(albumRepository: mockAlbumRepository);
    registerFallbackValue(const FetchAlbums());
    registerFallbackValue(const FetchPhotos(1));
  });

  tearDown(() {
    albumBloc.close();
  });

  testWidgets('Album list screen displays all albums in grid', (WidgetTester tester) async {
    final albums = [
      Album(userId: 1, id: 1, title: 'quidem molestiae enim'),
      Album(userId: 2, id: 2, title: 'sunt qui excepturi'),
    ];
    final photos = [
      Photo(id: 1, albumId: 1, title: 'accusamus beatae', url: 'url1', thumbnailUrl: 'thumbnail1'),
    ];
    when(() => mockAlbumRepository.getAlbums()).thenAnswer((_) async => albums);
    when(() => mockAlbumRepository.getPhotos(any())).thenAnswer((_) async => photos);

    await tester.pumpWidget(MyApp(albumRepository: mockAlbumRepository));
    albumBloc.add(const FetchAlbums());
    await tester.pumpAndSettle();

    expect(find.text('quidem molestiae enim'), findsOneWidget);
    expect(find.text('sunt qui excepturi'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(2));

    albumBloc.add(const FetchPhotos(1));
    await tester.pumpAndSettle();

    expect(find.byType(CachedNetworkImage), findsWidgets);
    expect(find.text('quidem molestiae enim'), findsOneWidget);
    expect(find.text('sunt qui excepturi'), findsOneWidget);
  });

  testWidgets('Navigates to detail screen, shows back button, and returns to list screen', (WidgetTester tester) async {
    final albums = [
      Album(userId: 1, id: 1, title: 'quidem molestiae enim'),
    ];
    final photos = [
      Photo(id: 1, albumId: 1, title: 'accusamus beatae', url: 'url', thumbnailUrl: 'thumbnail'),
    ];
    when(() => mockAlbumRepository.getAlbums()).thenAnswer((_) async => albums);
    when(() => mockAlbumRepository.getPhotos(any())).thenAnswer((_) async => photos);

    await tester.pumpWidget(MyApp(albumRepository: mockAlbumRepository));
    albumBloc.add(const FetchAlbums());
    await tester.pumpAndSettle();

    await tester.tap(find.text('quidem molestiae enim'));
    await tester.pumpAndSettle();

    expect(find.text('quidem molestiae enim'), findsOneWidget);
    expect(find.text('Album ID: 1'), findsOneWidget);
    expect(find.text('User ID: 1'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('quidem molestiae enim'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.text('No data available'), findsNothing);
  });
}