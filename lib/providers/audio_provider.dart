import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

/// Provides the [AudioRecorder] instance.
final audioRecorderProvider = Provider.autoDispose<AudioRecorder>((ref) {
  final recorder = AudioRecorder();
  ref.onDispose(() => recorder.dispose());
  return recorder;
});

/// Manages the recording state (whether it's currently active).
final isRecordingProvider = StateProvider<bool>((ref) => false);

/// Holds the audio stream when recording is active.
final audioStreamProvider = StateProvider<Stream<Uint8List>?>((ref) => null);

/// Holds the complete recorded audio data as raw bytes.
final recordedAudioBytesProvider = StateProvider.autoDispose<Uint8List?>((ref) => null);