import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song_model.dart';

import '../providers/audio_provider.dart';

import '../services/permission_service.dart';
import '../services/playlist_service.dart';

import '../widgets/mini_player.dart';
import '../widgets/song_tile.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  final PlaylistService _playlistService =
  PlaylistService();

  final PermissionService
  _permissionService =
  PermissionService();

  List<SongModel> _songs = [];

  bool _isLoading = true;

  bool _hasPermission = false;

  @override
  void initState() {

    super.initState();

    _initializeApp();
  }

  Future<void> _initializeApp() async {

    _hasPermission =
    await _permissionService
        .requestPermissions();

    if (_hasPermission) {

      await _loadSongs();
    }

    setState(() {

      _isLoading = false;
    });
  }

  Future<void> _loadSongs() async {

    try {

      final songs =
      await _playlistService
          .getAllSongs();

      setState(() {

        _songs = songs;
      });

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            'Error loading songs: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF191414),

      body: SafeArea(

        child: Column(

          children: [

            _buildAppBar(),

            Expanded(

              child: _isLoading

                  ? const Center(
                child:
                CircularProgressIndicator(),
              )

                  : !_hasPermission

                  ? _buildPermissionDenied()

                  : _songs.isEmpty

                  ? _buildNoSongs()

                  : _buildSongList(),
            ),

            Consumer<AudioProvider>(

              builder:
                  (context, provider, child) {

                if (provider.currentSong ==
                    null) {

                  return const SizedBox
                      .shrink();
                }

                return const MiniPlayer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {

    return Padding(

      padding:
      const EdgeInsets.all(16),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,

        children: [

          const Text(

            'My Music',

            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          IconButton(

            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),

            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSongList() {

    return ListView.builder(

      itemCount: _songs.length,

      itemBuilder: (context, index) {

        final song = _songs[index];

        return SongTile(

          song: song,

          onTap: () {

            context
                .read<AudioProvider>()
                .setPlaylist(
              _songs,
              index,
            );
          },
        );
      },
    );
  }

  Widget _buildPermissionDenied() {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          const Icon(
            Icons.music_off,
            size: 80,
            color: Colors.grey,
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(

            'Permission Required',

            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(

            'Please allow audio access',

            style: TextStyle(
              color: Colors.grey,
            ),

            textAlign:
            TextAlign.center,
          ),

          const SizedBox(
            height: 20,
          ),

          ElevatedButton(

            onPressed: () async {

              await openAppSettings();
            },

            child:
            const Text(
              'Open Settings',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSongs() {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          const Icon(
            Icons.music_note,
            size: 80,
            color: Colors.grey,
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(

            'No Music Found',

            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(

            'Add music files to device',

            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}