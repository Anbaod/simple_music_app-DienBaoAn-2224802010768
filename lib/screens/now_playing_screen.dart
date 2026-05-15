import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/duration_formatter.dart';
import '../l10n/app_localizations.dart';
import '../models/playback_state_model.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      body: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          final song = provider.currentSong;

          if (song == null) {
            return Center(
              child: Text(
                lang.noSongs,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, lang),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          _buildAlbumArt(song),

                          const SizedBox(height: 32),

                          _buildSongInfo(song),

                          const SizedBox(height: 32),

                          StreamBuilder<PlaybackState>(
                            stream: provider.playbackStateStream,
                            builder: (context, snapshot) {
                              final state = snapshot.data;

                              return ProgressBar(
                                position: state?.position ?? Duration.zero,
                                duration: state?.duration ?? Duration.zero,
                                onSeek: provider.seek,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          PlayerControls(provider: provider),

                          const SizedBox(height: 20),

                          _buildVolumeControl(provider),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations lang) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () => Navigator.pop(context),
          ),

          Text(
            lang.nowPlaying,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),

          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(SongModel song) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: song.albumArt != null
            ? Image.file(
          File(song.albumArt!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultArt();
          },
        )
            : _buildDefaultArt(),
      ),
    );
  }

  Widget _buildDefaultArt() {
    return Container(
      color: const Color(0xFF282828),
      child: const Icon(
        Icons.music_note,
        size: 100,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildSongInfo(SongModel song) {
    return Column(
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        Text(
          song.artist,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildVolumeControl(AudioProvider provider) {
    return Row(
      children: [
        const Icon(Icons.volume_down, color: Colors.white),

        Expanded(
          child: Slider(
            value: provider.volume,
            min: 0,
            max: 1,
            activeColor: const Color(0xFF1DB954),
            inactiveColor: Colors.grey,
            onChanged: provider.setVolume,
          ),
        ),

        const Icon(Icons.volume_up, color: Colors.white),
      ],
    );
  }
}