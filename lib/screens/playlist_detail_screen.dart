import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../services/playlist_service.dart';
import '../widgets/song_tile.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailScreen({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final PlaylistService _playlistService = PlaylistService();

  List<SongModel> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  Future<void> _loadPlaylistSongs() async {
    final playlistProvider = context.read<PlaylistProvider>();

    final currentPlaylist = playlistProvider.playlists.firstWhere(
          (p) => p.id == widget.playlist.id,
      orElse: () => widget.playlist,
    );

    final allSongs = await _playlistService.getAllSongs();

    final playlistSongs = currentPlaylist.songIds
        .map((songId) {
      try {
        return allSongs.firstWhere((song) => song.id == songId);
      } catch (_) {
        return null;
      }
    })
        .whereType<SongModel>()
        .toList();

    if (mounted) {
      setState(() {
        _songs = playlistSongs;
        _isLoading = false;
      });
    }
  }

  Future<void> _playAll() async {
    if (_songs.isEmpty) return;

    try {
      await context.read<AudioProvider>().setPlaylist(_songs, 0);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể phát playlist. Có thể có file bị lỗi.'),
        ),
      );
    }
  }

  Future<void> _playSong(int index) async {
    try {
      await context.read<AudioProvider>().setPlaylist(_songs, index);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể phát bài hát này. File có thể bị lỗi.'),
        ),
      );
    }
  }

  Future<void> _reorderSongs(
      String playlistId,
      int oldIndex,
      int newIndex,
      ) async {
    final provider = context.read<PlaylistProvider>();

    await provider.reorderSongsInPlaylist(
      playlistId,
      oldIndex,
      newIndex,
    );

    await _loadPlaylistSongs();
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlaylistProvider>();

    final currentPlaylist = playlistProvider.playlists.firstWhere(
          (p) => p.id == widget.playlist.id,
      orElse: () => widget.playlist,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF191414),
        elevation: 0,
        title: Text(
          currentPlaylist.name,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _playAll,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _songs.isEmpty
          ? _buildEmptyView()
          : _buildSongList(currentPlaylist.id),
    );
  }

  Widget _buildSongList(String playlistId) {
    return ReorderableListView.builder(
      itemCount: _songs.length,
      onReorder: (oldIndex, newIndex) {
        _reorderSongs(playlistId, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final song = _songs[index];

        return Container(
          key: ValueKey(song.id),
          child: SongTile(
            song: song,
            onTap: () => _playSong(index),
            onDelete: () async {
              await context.read<PlaylistProvider>().removeSongFromPlaylist(
                playlistId,
                song.id,
              );

              await _loadPlaylistSongs();
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_remove, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Playlist chưa có bài hát',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy thêm bài hát từ màn hình Bài hát',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}