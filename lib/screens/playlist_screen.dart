import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'playlist_detail_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/playlist_provider.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  Future<void> _showCreateDialog(BuildContext context) async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tạo playlist'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Tên playlist',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );

    if (name == null || name.isEmpty) return;

    context.read<PlaylistProvider>().createPlaylist(name);
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final provider = context.watch<PlaylistProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF191414),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(context, lang),

              const SizedBox(height: 20),

              Expanded(
                child: provider.playlists.isEmpty
                    ? _buildEmptyPlaylist()
                    : _buildPlaylistList(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations lang) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lang.playlist,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _showCreateDialog(context),
        ),
      ],
    );
  }

  Widget _buildPlaylistList(PlaylistProvider provider) {
    return ListView.builder(
      itemCount: provider.playlists.length,
      itemBuilder: (context, index) {
        final playlist = provider.playlists[index];

        return Card(
          color: const Color(0xFF282828),
          child: ListTile(
            leading: const Icon(Icons.playlist_play, color: Colors.white),
            title: Text(
              playlist.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${playlist.songIds.length} bài hát',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaylistDetailScreen(
                    playlist: playlist,
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                provider.deletePlaylist(playlist.id);
              },
            ),
          )
        );
      },
    );
  }

  Widget _buildEmptyPlaylist() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_play, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Chưa có playlist',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 8),
          Text(
            'Nhấn nút + để tạo playlist mới',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}