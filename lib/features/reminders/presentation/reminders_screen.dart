import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/reminders/data/reminder_providers.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';
import 'package:opendiet/features/reminders/presentation/reminders_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The reminders configuration screen (S-15, FR-020/FR-021).
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final remindersAsync = ref.watch(remindersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.remindersTitle)),
      body: remindersAsync.when(
        data: (reminders) => _RemindersBody(reminders: reminders),
        error: (error, stack) => Center(child: Text(l10n.remindersLoadError)),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _RemindersBody extends ConsumerWidget {
  const _RemindersBody({required this.reminders});

  final List<Reminder> reminders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifService = ref.watch(notificationServiceProvider);

    return FutureBuilder<bool>(
      future: notifService.checkPermissions(),
      builder: (context, snapshot) {
        final permissionDenied =
            snapshot.connectionState == ConnectionState.done &&
            snapshot.data == false;

        return Column(
          children: [
            if (permissionDenied) const _PermissionBanner(),
            Expanded(
              child: reminders.isEmpty
                  ? const _EmptyState()
                  : _ReminderList(reminders: reminders),
            ),
            if (reminders.isNotEmpty) const _AddButton(),
            const _LocalOnlyFooter(),
          ],
        );
      },
    );
  }
}

class _PermissionBanner extends ConsumerWidget {
  const _PermissionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.errorContainer,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.remindersPermissionDenied,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.remindersPermissionExplanation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _openSettings(context),
            child: Text(l10n.remindersOpenSettings),
          ),
        ],
      ),
    );
  }

  void _openSettings(BuildContext context) {
    // Platform-specific app settings opening is handled via MethodChannel.
    // Requires `open_settings` package or manual platform channel call.
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Boxicons.bx_bell,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.remindersEmpty,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _addReminder(context, ref),
            icon: const Icon(Boxicons.bx_plus),
            label: Text(l10n.remindersAdd),
          ),
        ],
      ),
    );
  }
}

class _ReminderList extends ConsumerWidget {
  const _ReminderList({required this.reminders});

  final List<Reminder> reminders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        final hour = reminder.hour.toString().padLeft(2, '0');
        final minute = reminder.minute.toString().padLeft(2, '0');
        final timeText = '$hour:$minute';

        return ListTile(
          leading: Icon(
            reminder.enabled ? Boxicons.bxs_bell : Boxicons.bx_bell_off,
            color: reminder.enabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          title: Text(timeText),
          subtitle: reminder.mealSlotId != null
              ? Text(reminder.mealSlotId!)
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: reminder.enabled,
                onChanged: (_) => ref
                    .read(remindersControllerProvider.notifier)
                    .toggleReminder(reminder.id),
              ),
              IconButton(
                key: Key('reminder-edit-${reminder.id}'),
                tooltip: AppLocalizations.of(context).remindersEdit,
                icon: const Icon(Boxicons.bx_pencil),
                onPressed: () => _editReminder(context, ref, reminder),
              ),
              IconButton(
                icon: const Icon(Boxicons.bx_trash),
                onPressed: () => _confirmDelete(context, ref, reminder),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editReminder(
    BuildContext context,
    WidgetRef ref,
    Reminder reminder,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminder.hour, minute: reminder.minute),
    );
    if (time == null) return;

    await ref
        .read(remindersControllerProvider.notifier)
        .updateReminderTime(reminder.id, hour: time.hour, minute: time.minute);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Reminder reminder) {
    final l10n = AppLocalizations.of(context);
    final hourPadded = reminder.hour.toString().padLeft(2, '0');
    final minutePadded = reminder.minute.toString().padLeft(2, '0');
    final timeText = '$hourPadded:$minutePadded';
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.remindersRemoveTitle),
          content: Text(l10n.remindersRemoveMessage(timeText)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.actionCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                unawaited(
                  ref
                      .read(remindersControllerProvider.notifier)
                      .deleteReminder(reminder.id),
                );
              },
              child: Text(l10n.remindersRemoveConfirm),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends ConsumerWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _addReminder(context, ref),
          icon: const Icon(Boxicons.bx_plus),
          label: Text(l10n.remindersAdd),
        ),
      ),
    );
  }
}

class _LocalOnlyFooter extends StatelessWidget {
  const _LocalOnlyFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        l10n.remindersLocalOnly,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

Future<void> _addReminder(BuildContext context, WidgetRef ref) async {
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (time != null) {
    await ref
        .read(remindersControllerProvider.notifier)
        .addReminder(hour: time.hour, minute: time.minute);
  }
}
