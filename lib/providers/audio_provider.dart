import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

final audioRecorderProvider = Provider.autoDispose<AudioRecorder>((ref) {
  final recorder = AudioRecorder();

  ref.onDispose(() {
    recorder.dispose();
    ref.read(isRecordingProvider.notifier).state = false;
  });

  return recorder;
});

final isRecordingProvider = StateProvider<bool>((ref) => false);

final audioStreamProvider = StateProvider<Stream<Uint8List>?>((ref) => null);
