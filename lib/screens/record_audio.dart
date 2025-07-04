import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:savvy_cart/providers/providers.dart';
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
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: isRecording
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child:
                isRecording ? const Icon(Icons.stop) : const Icon(Icons.mic),
            onPressed: () async {
              if (isRecording) {
                await recorder.cancel();
                ref.read(isRecordingProvider.notifier).state = false;
                ref.read(audioStreamProvider.notifier).state = null;
                return;
              }

              if (await recorder.hasPermission()) {
                final stream = await recorder.startStream(
                  const RecordConfig(encoder: AudioEncoder.pcm16bits),
                );
                ref.read(isRecordingProvider.notifier).state = true;
                ref.read(audioStreamProvider.notifier).state = stream;
              }
            },
          ),
        ),
      ),
    );
  }
}
