import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../services/permission_service.dart';
import '../services/playlist_service.dart';
import '../widgets/song_tile.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  final PlaylistService _playlistService = PlaylistService();
  final PermissionService _permissionService = PermissionService();

  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];

  bool _isLoading = true;
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() => _isLoading = true);

    final granted = await _permissionService.requestPermissions();

    if (!granted) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final songs = await _playlistService.getAllSongs();

    if (mounted) {
      setState(() {
        _songs = songs;
        _filteredSongs = songs;
        _isLoading = false;
      });
    }
  }

  void _searchSongs(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      _filteredSongs = _songs.where((song) {
        return song.title.toLowerCase().contains(lowerQuery) ||
            song.artist.toLowerCase().contains(lowerQuery) ||
            (song.album?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredSongs = _songs;
    });
  }

  Future<void> _playSong(int index) async {
    try {
      await context.read<AudioProvider>().setPlaylist(_filteredSongs, index);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể phát bài hát này. File có thể bị lỗi.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(lang),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSongs.isEmpty
                ? _buildEmptyView(lang)
                : _buildSongList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _isSearching
                ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: lang.search,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: _searchSongs,
            )
                : Text(
              lang.songs,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              if (_isSearching) {
                _stopSearch();
              } else {
                setState(() => _isSearching = true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadSongs,
          ),
        ],
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      itemCount: _filteredSongs.length,
      itemBuilder: (context, index) {
        final song = _filteredSongs[index];

        return SongTile(
          song: song,
          onTap: () => _playSong(index),
        );
      },
    );
  }

  Widget _buildEmptyView(AppLocalizations lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            lang.noSongs,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hãy thêm file MP3 vào Download hoặc Music',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}