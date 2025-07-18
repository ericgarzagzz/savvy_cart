import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:savvy_cart/providers/providers.dart';

class RecordButton extends ConsumerStatefulWidget {
  const RecordButton({super.key});

  @override
  ConsumerState<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends ConsumerState<RecordButton> {
  StreamSubscription<Uint8List>? _audioStreamSubscription;
  final _audioBytesBuilder = BytesBuilder();

  @override
  void dispose() {
    _audioStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = ref.watch(isRecordingProvider);
    final recorder = ref.watch(audioRecorderProvider);

    final primaryColor = Theme.of(context).colorScheme.primary;
    final lighterPrimaryColor = primaryColor.withValues(alpha: 0.4);
    final errorColor = Theme.of(context).colorScheme.error;
    final lighterErrorColor = errorColor.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: () async {
        if (isRecording) {
          await recorder.cancel();
          _audioStreamSubscription?.cancel();
          ref.read(isRecordingProvider.notifier).state = false;
          ref.read(audioStreamProvider.notifier).state = null;
          final recordedBytes = _audioBytesBuilder.takeBytes();
          if (kDebugMode) {
            print('Recording stopped. Total bytes: ${recordedBytes.length}');
          }
          ref.read(recordedAudioBytesProvider.notifier).state = recordedBytes;
          return;
        }

        if (await recorder.hasPermission()) {
          // Clear previous recording data
          _audioBytesBuilder.clear();
          ref.read(recordedAudioBytesProvider.notifier).state = null;

          final stream = await recorder.startStream(
            const RecordConfig(encoder: AudioEncoder.pcm16bits),
          );
          _audioStreamSubscription =
              stream.listen((data) {
                    _audioBytesBuilder.add(data);
                  })
                  as StreamSubscription<Uint8List>?;
          ref.read(isRecordingProvider.notifier).state = true;
          ref.read(audioStreamProvider.notifier).state = stream;
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outermost ring (lighter, subtle)
          Container(
            width: 164,
            height: 164,
            decoration: BoxDecoration(
              color: isRecording ? lighterErrorColor : lighterPrimaryColor,
              shape: BoxShape.circle,
            ),
          ),
          // Middle ring (primary color)
          Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              color: isRecording ? errorColor : primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          // Inner circle (lighter, icon holder)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }
}
