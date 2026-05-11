import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../models/playback_state_model.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191414),

      body: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          final song = provider.currentSong;

          if (song == null) {
            return const Center(
              child: Text(
                'No song playing',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [

                // App Bar
                _buildAppBar(context),

                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24),

                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        _buildAlbumArt(song),

                        const SizedBox(height: 40),

                        _buildSongInfo(song),

                        const SizedBox(height: 40),

                        StreamBuilder<PlaybackState>(
                          stream:
                          provider.playbackStateStream,

                          builder: (context, snapshot) {
                            final state = snapshot.data;

                            return ProgressBar(
                              position:
                              state?.position ??
                                  Duration.zero,

                              duration:
                              state?.duration ??
                                  Duration.zero,

                              onSeek: provider.seek,
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Controls
                        PlayerControls(
                          provider: provider,
                        ),
                      ],
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 32,
            ),

            onPressed: () {
              Navigator.pop(context);
            },
          ),

          const Text(
            'Now Playing',

            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),

          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),

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
        borderRadius: BorderRadius.circular(8),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),

        child: song.albumArt != null

            ? Image.file(
          File(song.albumArt!),
          fit: BoxFit.cover,
        )

            : Container(
          color: const Color(0xFF282828),

          child: const Icon(
            Icons.music_note,
            size: 100,
            color: Colors.grey,
          ),
        ),
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
        ),
      ],
    );
  }
}