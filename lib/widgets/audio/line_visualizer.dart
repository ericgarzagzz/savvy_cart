import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';

class LineVisualizer extends ConsumerStatefulWidget {
  final Color? color;
  const LineVisualizer({super.key, this.color});

  @override
  ConsumerState<LineVisualizer> createState() => _LineVisualizerState();
}

class _LineVisualizerState extends ConsumerState<LineVisualizer> {
  StreamSubscription<Uint8List>? _audioStreamSubscription;
  Uint8List? _latestAudioData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final audioStream = ref.watch(audioStreamProvider);
    if (audioStream != null && _audioStreamSubscription == null) {
      _audioStreamSubscription = audioStream.listen((data) {
        setState(() {
          _latestAudioData = data;
        });
      });
    } else if (audioStream == null && _audioStreamSubscription != null) {
      _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;
      setState(() {
        _latestAudioData = null;
      });
    }
  }

  @override
  void dispose() {
    _audioStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 150),
      painter: LineVisualizerPainter(
        audioData: _latestAudioData,
        color: widget.color ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class LineVisualizerPainter extends CustomPainter {
  final Uint8List? audioData;
  final Color color;
  final int numberOfBars;

  LineVisualizerPainter({
    required this.audioData,
    required this.color,
    this.numberOfBars = 30,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (audioData == null || audioData!.isEmpty) return;

    final paint = Paint()..color = color;
    final barWidth = size.width / (numberOfBars * 2);
    final spacing = barWidth;

    // Create a ByteData view to correctly read 16-bit PCM data.
    final byteData = audioData!.buffer.asByteData(
      audioData!.offsetInBytes,
      audioData!.lengthInBytes,
    );
    final samples = byteData.lengthInBytes ~/ 2; // Each sample is 2 bytes

    final chunkSize = (samples / numberOfBars).floor();
    if (chunkSize == 0) return;

    for (int i = 0; i < numberOfBars; i++) {
      final chunkStart = i * chunkSize;
      final chunkEnd = chunkStart + chunkSize;

      double sum = 0;
      for (int j = chunkStart; j < chunkEnd; j++) {
        // Read a 16-bit signed integer for each sample.
        final sample = byteData.getInt16(j * 2, Endian.little);
        sum += sample.abs();
      }
      final averageAmplitude = sum / chunkSize;

      // Adjust noise gate for the 16-bit audio range.
      const noiseGate = 20.0;
      final amplitude = max(0.0, averageAmplitude - noiseGate);

      // Max amplitude for 16-bit signed audio is 32767.
      final maxAmplitude = 32767.0 - noiseGate;
      final normalizedAmplitude = (amplitude / maxAmplitude).clamp(0.0, 1.0);

      // Use a power function to make the response more dynamic and visually appealing.
      final barHeight = pow(normalizedAmplitude, 0.7) * size.height;

      final x = spacing + i * (barWidth + spacing);
      // Draw from the center outwards.
      final y = (size.height / 2) - (barHeight / 2);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LineVisualizerPainter oldDelegate) {
    return oldDelegate.audioData != audioData || oldDelegate.color != color;
  }
}
