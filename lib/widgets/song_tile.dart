import 'dart:io';

import 'package:flutter/material.dart';

import '../models/song_model.dart';

class SongTile extends StatelessWidget {

  final SongModel song;

  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        child: Row(

          children: [

            _buildAlbumArt(),

            const SizedBox(width: 12),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    song.title,

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w600,
                      fontSize: 16,
                    ),

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(

                    song.artist,

                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            IconButton(

              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),

              onPressed: () {

                _showOptionsMenu(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {

    return Container(

      width: 55,

      height: 55,

      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(8),

        color: const Color(
          0xFF282828,
        ),
      ),

      child: ClipRRect(

        borderRadius:
        BorderRadius.circular(8),

        child: song.albumArt != null

            ? Image.file(

          File(song.albumArt!),

          fit: BoxFit.cover,

          errorBuilder:
              (
              context,
              error,
              stackTrace,
              ) {

            return _buildFallbackArt();
          },
        )

            : _buildFallbackArt(),
      ),
    );
  }

  Widget _buildFallbackArt() {

    return const Icon(
      Icons.music_note,
      color: Colors.grey,
      size: 28,
    );
  }

  void _showOptionsMenu(
      BuildContext context,
      ) {

    showModalBottomSheet(

      context: context,

      backgroundColor:
      const Color(0xFF282828),

      shape: const RoundedRectangleBorder(

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (context) {

        return SafeArea(

          child: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              const SizedBox(height: 12),

              Container(

                width: 40,

                height: 4,

                decoration: BoxDecoration(

                  color: Colors.grey,

                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ListTile(

                leading: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),

                title: const Text(

                  'Add to playlist',

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                onTap: () {

                  Navigator.pop(context);
                },
              ),

              ListTile(

                leading: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),

                title: const Text(

                  'Share',

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                onTap: () {

                  Navigator.pop(context);
                },
              ),

              ListTile(

                leading: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),

                title: const Text(

                  'Song info',

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                onTap: () {

                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}