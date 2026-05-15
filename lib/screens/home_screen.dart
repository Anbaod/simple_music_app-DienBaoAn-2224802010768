import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recent_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/audio_provider.dart';
import '../widgets/mini_player.dart';
import 'all_songs_screen.dart';
import 'playlist_screen.dart';
import 'settings_screen.dart';
import '../utils/constants.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    AllSongsScreen(),
    PlaylistScreen(),
    RecentScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      body: Column(
        children: [
          Expanded(child: _screens[_selectedIndex]),

          Consumer<AudioProvider>(
            builder: (context, provider, child) {
              if (provider.currentSong == null) return const SizedBox.shrink();
              return const MiniPlayer();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF282828),
        selectedItemColor: const Color(0xFF1DB954),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.music_note),
            label: lang.songs,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.playlist_play),
            label: lang.playlist,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: lang.settings,
          ),

        ],
      ),
    );
  }
}