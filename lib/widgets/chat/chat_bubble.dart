import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageViewModel messageViewModel;
  final VoidCallback? onRetry;
  final VoidCallback? onViewActions;
  final VoidCallback? onViewExecutedActions;
  final bool isLastMessage;
  final bool isLatestAiMessage;

  const ChatBubble({
    super.key,
    required this.messageViewModel,
    this.onRetry,
    this.onViewActions,
    this.onViewExecutedActions,
    this.isLastMessage = false,
    this.isLatestAiMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: messageViewModel.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!messageViewModel.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: messageViewModel.isError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.secondary,
              child: Icon(
                messageViewModel.isError ? Icons.error : Icons.smart_toy,
                size: 16,
                color: messageViewModel.isError
                    ? Theme.of(context).colorScheme.onError
                    : Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: messageViewModel.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (messageViewModel.isError && !messageViewModel.isUser) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 18,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            messageViewModel.text,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      messageViewModel.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: messageViewModel.isUser
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                  if (messageViewModel.isError &&
                      onRetry != null &&
                      isLastMessage) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: Icon(
                        Icons.refresh,
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      label: Text(
                        AppLocalizations.of(context).retry,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                  if (!messageViewModel.isError &&
                      !messageViewModel.isUser &&
                      messageViewModel.hasActions) ...[
                    const SizedBox(height: 8),
                    if (messageViewModel.actionsExecuted) ...[
                      // Actions were executed - show review button
                      ElevatedButton.icon(
                        onPressed: onViewExecutedActions,
                        icon: Icon(Icons.check_circle, size: 18),
                        label: Text(
                          AppLocalizations.of(context).actionsApplied,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ] else if (isLatestAiMessage) ...[
                      // Latest AI message - show apply button
                      ElevatedButton.icon(
                        onPressed: onViewActions,
                        icon: Icon(Icons.playlist_add_check, size: 18),
                        label: Text(
                          AppLocalizations.of(context).applyActions,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ] else ...[
                      // Not latest AI message - actions are considered discarded
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              size: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context).actionsDiscarded,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          if (messageViewModel.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
