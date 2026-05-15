import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../services/storage_service.dart';
import '../widgets/song_tile.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  final StorageService _storageService = StorageService();

  List<SongModel> _recentSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentSongs();
  }

  Future<void> _loadRecentSongs() async {
    final songs = await _storageService.getRecentSongs();

    if (mounted) {
      setState(() {
        _recentSongs = songs;
        _isLoading = false;
      });
    }
  }

  Future<void> _playSong(int index) async {
    try {
      await context.read<AudioProvider>().setPlaylist(
        _recentSongs,
        index,
      );

      await _loadRecentSongs();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể phát bài hát này'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lang.recent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _recentSongs.isEmpty
                  ? _buildEmptyView(lang)
                  : _buildSongList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      itemCount: _recentSongs.length,
      itemBuilder: (context, index) {
        final song = _recentSongs[index];

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
          const Icon(
            Icons.history,
            size: 80,
            color: Colors.grey,
          ),

          const SizedBox(height: 16),

          Text(
            lang.noRecentSongs,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}