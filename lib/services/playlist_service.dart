import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio;

import '../models/song_model.dart';

class PlaylistService {
  final audio.OnAudioQuery _audioQuery = audio.OnAudioQuery();

  Future<List<SongModel>> getAllSongs() async {
    try {
      final List<audio.SongModel> audioList = await _audioQuery.querySongs(
        sortType: null,
        orderType: audio.OrderType.ASC_OR_SMALLER,
        uriType: audio.UriType.EXTERNAL,
        ignoreCase: true,
      );

      print('DEVICE SONGS FOUND: ${audioList.length}');

      return audioList
          .where((audioSong) {
        final path = audioSong.data.toLowerCase();
        return path.endsWith('.mp3') ||
            path.endsWith('.m4a') ||
            path.endsWith('.wav') ||
            path.endsWith('.aac');
      })
          .map((audioSong) => SongModel.fromAudioQuery(audioSong))
          .toList();
    } catch (e) {
      print('Error loading device songs: $e');
      return [];
    }
  }

  Future<List<SongModel>> getSampleSongs() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final assetSongs = manifestMap.keys.where((path) {
        final lowerPath = path.toLowerCase();

        return lowerPath.startsWith('assets/audio/sample_songs/') &&
            lowerPath.endsWith('.mp3');
      }).toList();

      print('ASSET SONGS FOUND: ${assetSongs.length}');
      print(assetSongs);

      return assetSongs.asMap().entries.map((entry) {
        final index = entry.key;
        final path = entry.value;
        final fileName = path.split('/').last.replaceAll('.mp3', '');

        return SongModel(
          id: 'asset_$index',
          title: fileName,
          artist: 'Sample Artist',
          album: 'Sample Songs',
          filePath: path,
          duration: null,
        );
      }).toList();
    } catch (e) {
      print('Error loading asset songs: $e');
      return [];
    }
  }

  Future<List<SongModel>> getSongsWithFallback() async {
    final deviceSongs = await getAllSongs();

    if (deviceSongs.isNotEmpty) {
      return deviceSongs;
    }

    return await getSampleSongs();
  }

  Future<List<SongModel>> getSongsByArtist(String artist) async {
    final allSongs = await getSongsWithFallback();

    return allSongs.where((song) {
      return song.artist.toLowerCase() == artist.toLowerCase();
    }).toList();
  }

  Future<List<SongModel>> getSongsByAlbum(String album) async {
    final allSongs = await getSongsWithFallback();

    return allSongs.where((song) {
      return song.album?.toLowerCase() == album.toLowerCase();
    }).toList();
  }

  Future<List<SongModel>> searchSongs(String query) async {
    final allSongs = await getSongsWithFallback();
    final lowerQuery = query.toLowerCase();

    return allSongs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery) ||
          (song.album?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}