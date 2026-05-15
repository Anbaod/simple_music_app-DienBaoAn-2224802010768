import 'package:flutter/material.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../services/storage_service.dart';

class PlaylistProvider extends ChangeNotifier {
  final StorageService _storageService;

  PlaylistProvider(this._storageService) {
    loadPlaylists();
  }

  List<PlaylistModel> _playlists = [];

  List<PlaylistModel> get playlists => _playlists;

  Future<void> loadPlaylists() async {
    _playlists = await _storageService.getPlaylists();
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    final playlist = PlaylistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _playlists.add(playlist);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> deletePlaylist(String playlistId) async {
    _playlists.removeWhere((playlist) => playlist.id == playlistId);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> renamePlaylist(String playlistId, String newName) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    _playlists[index] = _playlists[index].copyWith(name: newName);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> addSongToPlaylist(String playlistId, SongModel song) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final playlist = _playlists[index];

    if (playlist.songIds.contains(song.id)) return;

    final updatedSongIds = List<String>.from(playlist.songIds)..add(song.id);

    _playlists[index] = playlist.copyWith(songIds: updatedSongIds);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final playlist = _playlists[index];
    final updatedSongIds = List<String>.from(playlist.songIds)..remove(songId);

    _playlists[index] = playlist.copyWith(songIds: updatedSongIds);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }
  Future<void> reorderSongsInPlaylist(
      String playlistId,
      int oldIndex,
      int newIndex,
      ) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final playlist = _playlists[index];
    final songIds = List<String>.from(playlist.songIds);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final songId = songIds.removeAt(oldIndex);
    songIds.insert(newIndex, songId);

    _playlists[index] = playlist.copyWith(songIds: songIds);
    await _storageService.savePlaylists(_playlists);

    notifyListeners();
  }
}