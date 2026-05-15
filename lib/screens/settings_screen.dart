import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/audio_provider.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _repeatText(BuildContext context, dynamic loopMode) {
    final lang = AppLocalizations.of(context)!;
    final value = loopMode.toString();

    if (value.contains('off')) return lang.off;
    if (value.contains('all')) return lang.repeatAll;
    if (value.contains('one')) return lang.repeatOne;

    return lang.unknown;
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final audioProvider = context.watch<AudioProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF191414),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
          children: [
            Text(
              lang.settings,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle(lang.playback),

            SwitchListTile(
              activeColor: const Color(0xFF1DB954),
              contentPadding: EdgeInsets.zero,
              value: audioProvider.isShuffleEnabled,
              onChanged: (_) => audioProvider.toggleShuffle(),
              secondary: const Icon(Icons.shuffle, color: Colors.white),
              title: Text(
                lang.shuffle,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                audioProvider.isShuffleEnabled ? lang.on : lang.off,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.repeat, color: Colors.white),
              title: Text(
                lang.repeat,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _repeatText(context, audioProvider.loopMode),
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: audioProvider.toggleRepeat,
            ),

            const SizedBox(height: 16),

            _buildSectionTitle(lang.volume),

            Slider(
              value: audioProvider.volume,
              min: 0,
              max: 1,
              activeColor: const Color(0xFF1DB954),
              inactiveColor: Colors.grey[800],
              onChanged: audioProvider.setVolume,
            ),

            const SizedBox(height: 16),

            _buildSectionTitle(lang.language),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language, color: Colors.white),
              title: Text(
                lang.language,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                languageProvider.locale.languageCode == 'vi'
                    ? lang.vietnamese
                    : lang.english,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: DropdownButton<String>(
                value: languageProvider.locale.languageCode,
                dropdownColor: const Color(0xFF282828),
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: 'vi',
                    child: Text(
                      lang.vietnamese,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(
                      lang.english,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    languageProvider.changeLanguage(value);
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            _buildSectionTitle(lang.app),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: Text(
                lang.appInfo,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Simple Music App - Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1DB954),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}