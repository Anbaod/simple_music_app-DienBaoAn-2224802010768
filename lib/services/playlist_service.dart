import 'package:on_audio_query/on_audio_query.dart'
  as audio;

import '../models/song_model.dart';

class PlaylistService {

  final audio.OnAudioQuery _audioQuery =
  audio.OnAudioQuery();

  Future<List<SongModel>> getAllSongs() async {

    try {

      final List<audio.SongModel> audioList =
      await _audioQuery.querySongs(
        sortType: audio.SongSortType.TITLE,
        orderType:
        audio.OrderType.ASC_OR_SMALLER,
        uriType: audio.UriType.EXTERNAL,
        ignoreCase: true,
      );

      return audioList
          .map(
            (audioSong) =>
            SongModel.fromAudioQuery(
                audioSong),
      )
          .toList();

    } catch (e) {

      throw Exception(
        'Error loading songs: $e',
      );
    }
  }

  Future<List<SongModel>> getSongsByArtist(
      String artist,
      ) async {

    final allSongs = await getAllSongs();

    return allSongs.where(
          (song) =>
      song.artist.toLowerCase() ==
          artist.toLowerCase(),
    ).toList();
  }

  Future<List<SongModel>> getSongsByAlbum(
      String album,
      ) async {

    final allSongs = await getAllSongs();

    return allSongs.where(
          (song) =>
      song.album?.toLowerCase() ==
          album.toLowerCase(),
    ).toList();
  }

  Future<List<SongModel>> searchSongs(
      String query,
      ) async {

    final allSongs = await getAllSongs();

    final lowerQuery =
    query.toLowerCase();

    return allSongs.where((song) {

      return song.title
          .toLowerCase()
          .contains(lowerQuery) ||

          song.artist
              .toLowerCase()
              .contains(lowerQuery) ||

          (song.album
              ?.toLowerCase()
              .contains(lowerQuery) ??
              false);

    }).toList();
  }
}