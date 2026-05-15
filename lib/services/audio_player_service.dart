import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/playback_state_model.dart';
import '../models/song_model.dart';
import 'audio_handler_service.dart';

class AudioPlayerService {
  final MyAudioHandler _handler;

  AudioPlayerService(this._handler);

  AudioPlayer get _audioPlayer => _handler.player;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  Duration get currentPosition => _audioPlayer.position;
  Duration? get currentDuration => _audioPlayer.duration;
  bool get isPlaying => _audioPlayer.playing;

  Stream<PlaybackState> get playbackStateStream {
    return Rx.combineLatest3<Duration, Duration?, bool, PlaybackState>(
      positionStream,
      durationStream,
      playingStream,
          (position, duration, isPlaying) {
        return PlaybackState(
          position: position,
          duration: duration ?? Duration.zero,
          isPlaying: isPlaying,
        );
      },
    );
  }

  Future<void> loadSong(SongModel song) async {
    await _handler.loadSong(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      filePath: song.filePath,
    );
  }

  Future<void> play() => _handler.play();

  Future<void> pause() => _handler.pause();

  Future<void> stop() => _handler.stop();

  Future<void> seek(Duration position) => _handler.seek(position);

  Future<void> setVolume(double volume) => _handler.setVolume(volume);

  Future<void> setSpeed(double speed) => _handler.setSpeed(speed);

  Future<void> setLoopMode(LoopMode loopMode) => _handler.setLoopMode(loopMode);

  Future<void> dispose() => _handler.disposePlayer();
}