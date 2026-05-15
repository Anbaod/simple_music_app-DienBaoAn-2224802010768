import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';

class StorageService {
  static const String _playlistsKey = 'playlists';
  static const String _customSongsKey = 'custom_songs';
  static const String _lastPlayedKey = 'last_played';
  static const String _shuffleKey = 'shuffle_enabled';
  static const String _repeatKey = 'repeat_mode';
  static const String _volumeKey = 'volume';
  static const String _lastPositionKey = 'last_position';
  static const String _recentSongsKey = 'recent_songs';

  Future<void> savePlaylists(List<PlaylistModel> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final playlistsJson = playlists.map((p) => p.toJson()).toList();
    await prefs.setString(_playlistsKey, json.encode(playlistsJson));
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistsString = prefs.getString(_playlistsKey);

    if (playlistsString != null) {
      final List<dynamic> playlistsJson = json.decode(playlistsString);
      return playlistsJson.map((json) => PlaylistModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> saveCustomSongs(List<SongModel> songs) async {
    final prefs = await SharedPreferences.getInstance();
    final songsJson = songs.map((song) => song.toJson()).toList();
    await prefs.setString(_customSongsKey, json.encode(songsJson));
  }

  Future<List<SongModel>> getCustomSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final songsString = prefs.getString(_customSongsKey);

    if (songsString != null) {
      final List<dynamic> songsJson = json.decode(songsString);
      return songsJson.map((json) => SongModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> addCustomSong(SongModel song) async {
    final songs = await getCustomSongs();
    songs.add(song);
    await saveCustomSongs(songs);
  }

  Future<void> saveLastPlayed(String songId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPlayedKey, songId);
  }

  Future<String?> getLastPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastPlayedKey);
  }

  Future<void> saveShuffleState(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shuffleKey, enabled);
  }

  Future<bool> getShuffleState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_shuffleKey) ?? false;
  }

  Future<void> saveRepeatMode(int mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_repeatKey, mode);
  }

  Future<int> getRepeatMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_repeatKey) ?? 0;
  }

  Future<void> saveVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, volume);
  }

  Future<double> getVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_volumeKey) ?? 1.0;
  }
  Future<void> deleteCustomSong(String songId) async {
    final songs = await getCustomSongs();
    songs.removeWhere((song) => song.id == songId);
    await saveCustomSongs(songs);
  }
  Future<void> deletePlaylist(String playlistId) async {
    final playlists = await getPlaylists();
    playlists.removeWhere((playlist) => playlist.id == playlistId);
    await savePlaylists(playlists);
  }

  Future<void> updatePlaylist(PlaylistModel updatedPlaylist) async {
    final playlists = await getPlaylists();
    final index = playlists.indexWhere((p) => p.id == updatedPlaylist.id);

    if (index != -1) {
      playlists[index] = updatedPlaylist;
      await savePlaylists(playlists);
    }
  }
  Future<void> saveLastPosition(int milliseconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPositionKey, milliseconds);
  }

  Future<int> getLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastPositionKey) ?? 0;
  }
  Future<void> saveRecentSong(SongModel song) async {
    final recentSongs = await getRecentSongs();

    recentSongs.removeWhere((s) => s.id == song.id);
    recentSongs.insert(0, song);

    if (recentSongs.length > 20) {
      recentSongs.removeLast();
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _recentSongsKey,
      json.encode(recentSongs.map((s) => s.toJson()).toList()),
    );
  }

  Future<List<SongModel>> getRecentSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_recentSongsKey);

    if (jsonString == null) return [];

    final List decoded = json.decode(jsonString);

    return decoded.map((e) => SongModel.fromJson(e)).toList();
  }
}