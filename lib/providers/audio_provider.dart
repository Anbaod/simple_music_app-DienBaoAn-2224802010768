import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/playback_state_model.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';
import '../services/storage_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService;
  final StorageService _storageService;

  List<SongModel> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffleEnabled = false;
  LoopMode _loopMode = LoopMode.off;
  double _volume = 1.0;

  AudioProvider(this._audioService, this._storageService) {
    _init();
  }

  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isShuffleEnabled => _isShuffleEnabled;
  LoopMode get loopMode => _loopMode;
  double get volume => _volume;

  SongModel? get currentSong {
    if (_playlist.isEmpty) return null;
    if (_currentIndex < 0 || _currentIndex >= _playlist.length) return null;
    return _playlist[_currentIndex];
  }

  Stream<Duration> get positionStream => _audioService.positionStream;
  Stream<Duration?> get durationStream => _audioService.durationStream;
  Stream<bool> get playingStream => _audioService.playingStream;
  Stream<PlaybackState> get playbackStateStream => _audioService.playbackStateStream;

  Future<void> _init() async {
    _isShuffleEnabled = await _storageService.getShuffleState();

    final repeatMode = await _storageService.getRepeatMode();
    _loopMode = LoopMode.values[repeatMode];

    await _audioService.setLoopMode(_loopMode);

    _volume = await _storageService.getVolume();
    await _audioService.setVolume(_volume);

    _audioService.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        if (_loopMode == LoopMode.one) {
          await _audioService.seek(Duration.zero);
          await _audioService.play();
        } else {
          await next();
        }
      }
    });

    notifyListeners();
  }

  Future<void> setPlaylist(List<SongModel> songs, int startIndex) async {
    if (songs.isEmpty) return;

    _playlist = songs;
    _currentIndex = startIndex;

    await _playSongAtIndex(_currentIndex);

    notifyListeners();
  }

  Future<void> _playSongAtIndex(int index) async {
    if (_playlist.isEmpty) return;
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    try {
      await _audioService.loadSong(song);

      final lastPlayedId = await _storageService.getLastPlayed();

      if (lastPlayedId == song.id) {
        final lastPosition = await _storageService.getLastPosition();

        if (lastPosition > 0) {
          await _audioService.seek(
            Duration(milliseconds: lastPosition),
          );
        }
      }

      await _audioService.play();
      await _storageService.saveLastPlayed(song.id);
      await _storageService.saveRecentSong(song);

      notifyListeners();
    } catch (e) {
      debugPrint('Play error: $e');
      rethrow;
    }
  }

  Future<void> saveCurrentPosition() async {
    await _storageService.saveLastPosition(
      _audioService.currentPosition.inMilliseconds,
    );
  }

  Future<void> pause() async {
    await saveCurrentPosition();
    await _audioService.pause();
    notifyListeners();
  }

  Future<void> playPause() async {
    if (_audioService.isPlaying) {
      await pause();
    } else {
      await _audioService.play();
      notifyListeners();
    }
  }

  Future<void> next() async {
    if (_playlist.isEmpty) return;

    await saveCurrentPosition();

    if (_isShuffleEnabled) {
      _currentIndex = _getRandomIndex();
      await _playSongAtIndex(_currentIndex);
      return;
    }

    if (_loopMode == LoopMode.all) {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
      await _playSongAtIndex(_currentIndex);
      return;
    }

    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      await _playSongAtIndex(_currentIndex);
    } else {
      await pause();
    }
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) return;

    await saveCurrentPosition();

    if (_audioService.currentPosition.inSeconds > 3) {
      await _audioService.seek(Duration.zero);
      return;
    }

    if (_isShuffleEnabled) {
      _currentIndex = _getRandomIndex();
    } else {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    }

    await _playSongAtIndex(_currentIndex);
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
    await saveCurrentPosition();
  }

  Future<void> toggleShuffle() async {
    _isShuffleEnabled = !_isShuffleEnabled;
    await _storageService.saveShuffleState(_isShuffleEnabled);
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        _loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        _loopMode = LoopMode.off;
        break;
    }

    await _audioService.setLoopMode(_loopMode);
    await _storageService.saveRepeatMode(_loopMode.index);

    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _audioService.setVolume(volume);
    await _storageService.saveVolume(volume);
    notifyListeners();
  }

  int _getRandomIndex() {
    if (_playlist.length <= 1) return 0;

    final random = Random();
    int newIndex;

    do {
      newIndex = random.nextInt(_playlist.length);
    } while (newIndex == _currentIndex);

    return newIndex;
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}