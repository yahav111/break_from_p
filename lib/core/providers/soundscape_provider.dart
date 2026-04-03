import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class SoundscapeState {
  const SoundscapeState({
    this.isPlaying = false,
    this.currentSoundscape,
    this.volume = 0.8,
    this.timerMinutes,
    this.error,
  });

  final bool isPlaying;
  final String? currentSoundscape;
  final double volume;
  final int? timerMinutes;
  final String? error;

  SoundscapeState copyWith({
    bool? isPlaying,
    String? currentSoundscape,
    bool clearCurrentSoundscape = false,
    double? volume,
    int? timerMinutes,
    bool clearTimerMinutes = false,
    String? error,
    bool clearError = false,
  }) {
    return SoundscapeState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentSoundscape:
          clearCurrentSoundscape ? null : (currentSoundscape ?? this.currentSoundscape),
      volume: volume ?? this.volume,
      timerMinutes:
          clearTimerMinutes ? null : (timerMinutes ?? this.timerMinutes),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final soundscapeNotifierProvider =
    NotifierProvider<SoundscapeNotifier, SoundscapeState>(
        SoundscapeNotifier.new);

class SoundscapeNotifier extends Notifier<SoundscapeState> {
  late final AudioPlayer _player;
  Timer? _sleepTimer;
  bool _busy = false;
  bool _sessionConfigured = false;

  @override
  SoundscapeState build() {
    _player = AudioPlayer();
    ref.onDispose(() {
      _cancelTimer();
      _player.dispose();
    });
    return const SoundscapeState();
  }

  Future<void> _ensureSession() async {
    if (_sessionConfigured) return;
    try {
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
      await session.setActive(true);
      _sessionConfigured = true;
    } catch (e) {
      debugPrint('[Soundscape] audio session error: $e');
    }
  }

  Future<void> play(String soundscape) async {
    if (_busy) return;
    _busy = true;
    try {
      state = state.copyWith(clearError: true);

      // Same sound already playing — no-op.
      if (state.currentSoundscape == soundscape && _player.playing) return;

      // Same sound paused — just resume.
      if (state.currentSoundscape == soundscape) {
        _player.play();
        state = state.copyWith(isPlaying: true);
        return;
      }

      // New sound — stop current, configure session, load new.
      if (_player.playing) {
        await _player.stop();
      }

      await _ensureSession();
      await _player.setAsset(soundscape);
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(state.volume);
      _player.play();

      state = state.copyWith(
        isPlaying: true,
        currentSoundscape: soundscape,
      );
    } catch (e, st) {
      debugPrint('[Soundscape] play error: $e\n$st');
      state = state.copyWith(isPlaying: false, error: e.toString());
    } finally {
      _busy = false;
    }
  }

  Future<void> pause() async {
    try {
      _player.pause();
      state = state.copyWith(isPlaying: false);
    } catch (e) {
      debugPrint('[Soundscape] pause error: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else if (state.currentSoundscape != null) {
      await play(state.currentSoundscape!);
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    _cancelTimer();
    state = const SoundscapeState();
  }

  void setVolume(double volume) {
    _player.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  void setTimer(int? minutes) {
    _cancelTimer();
    if (minutes != null) {
      _sleepTimer = Timer(Duration(minutes: minutes), () {
        stop();
      });
      state = state.copyWith(timerMinutes: minutes);
    } else {
      state = state.copyWith(clearTimerMinutes: true);
    }
  }

  void _cancelTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
  }
}
