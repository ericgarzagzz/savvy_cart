import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/audio/line_visualizer.dart';
import 'package:savvy_cart/widgets/audio/record_button.dart';
import 'package:savvy_cart/widgets/generic_alert_dialog.dart';
import 'package:savvy_cart/widgets/generic_error_scaffold.dart';

class RecordAudio extends ConsumerWidget {
  final int shopListId;

  const RecordAudio({super.key, required this.shopListId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getShopListByIdAsync = ref.watch(
      getShopListByIdProvider(shopListId),
    );
    final isRecording = ref.watch(isRecordingProvider);
    final recorder = ref.watch(audioRecorderProvider);

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) =>
          GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => PopScope(
        canPop: !isRecording,
        onPopInvoked: (didPop) {
          if (didPop) return;
          GenericAlertDialog.show(
            context,
            title: 'Cancel Recording?',
            message:
                'If you go back, the current recording will be canceled.',
            confirmText: 'Yes, cancel',
            onConfirm: () {
              recorder.cancel();
              ref.read(isRecordingProvider.notifier).state = false;
              ref.read(audioStreamProvider.notifier).state = null;
              ref.read(recordedAudioBytesProvider.notifier).state = null; // Clear recorded data
              Navigator.of(context).pop(); // Dismiss the dialog
              Navigator.of(context).pop(); // Pop the page
            },
          );
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text("Add by Voice to ${shopList.name}"),
                pinned: true,
                expandedHeight: 100,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          isRecording
                              ? 'Tap the stop icon to finish recording'
                              : 'Tap the microphone to start recording',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: RecordButton(),
                    ),
                  ],
                ),
              ),
              if (isRecording)
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineVisualizer(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              Consumer(
                builder: (context, ref, child) {
                  final recordedAudioBytes = ref.watch(recordedAudioBytesProvider);
                  if (!isRecording && recordedAudioBytes != null) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 50), // Make button full width and tall
                          ),
                          onPressed: () {
                            // TODO: Implement audio processing logic here
                            print('Processing audio: ${recordedAudioBytes.length} bytes');
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Process Audio'),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
