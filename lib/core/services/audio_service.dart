import 'dart:async';
import 'dart:ui' show VoidCallback;

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

/// Wraps [AudioPlayer] from just_audio for soundscape playback.
class AudioService {
  AudioService({this.onStopped});

  final AudioPlayer _player = AudioPlayer();
  Timer? _sleepTimer;
  String? _currentAsset;
  bool _sessionConfigured = false;

  /// Called when playback stops automatically (e.g. sleep timer expiry).
  final VoidCallback? onStopped;

  /// Whether the player is currently playing audio.
  bool get isPlaying => _player.playing;

  /// The asset path of the currently loaded sound, or null if nothing is loaded.
  String? get currentAsset => _currentAsset;

  /// Stream that emits the current playing state.
  Stream<bool> get playingStream => _player.playingStream;

  /// Configure the audio session for playback (called once lazily).
  Future<void> _ensureSession() async {
    if (_sessionConfigured) return;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    ));
    _sessionConfigured = true;
  }

  /// Play a soundscape from the given [assetPath].
  ///
  /// If the same asset is already playing, this is a no-op.
  /// Sets loop mode to repeat the single track indefinitely.
  Future<void> play(String assetPath) async {
    // Already playing this sound — nothing to do.
    if (_currentAsset == assetPath && _player.playing) return;

    // Same sound paused — just resume without reloading.
    if (_currentAsset == assetPath) {
      await _player.play();
      return;
    }

    await _ensureSession();
    await _player.setAsset(assetPath);
    await _player.setLoopMode(LoopMode.one);
    _currentAsset = assetPath;
    await _player.play();
  }

  /// Pause the current playback.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback after a pause.
  Future<void> resume() async {
    await _player.play();
  }

  /// Stop playback entirely and clear the current asset.
  Future<void> stop() async {
    await _player.stop();
    _currentAsset = null;
    cancelTimer();
  }

  /// Set the playback volume (0.0 – 1.0).
  void setVolume(double volume) {
    _player.setVolume(volume);
  }

  /// Start a sleep timer that will automatically stop playback after
  /// [minutes] minutes. Cancels any previously running timer.
  void setTimer(int minutes) {
    cancelTimer();
    _sleepTimer = Timer(Duration(minutes: minutes), () async {
      await stop();
      onStopped?.call();
    });
  }

  /// Cancel any running sleep timer.
  void cancelTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
  }

  /// Release all resources held by the underlying player.
  void dispose() {
    cancelTimer();
    _player.dispose();
  }
}
