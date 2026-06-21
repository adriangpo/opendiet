import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/default_meal_slots.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Meal-slot management screen (S-14, FR-019).
class MealSlotsScreen extends ConsumerStatefulWidget {
  /// Creates the meal-slot management screen.
  const MealSlotsScreen({super.key});

  @override
  ConsumerState<MealSlotsScreen> createState() => _MealSlotsScreenState();
}

class _MealSlotsScreenState extends ConsumerState<MealSlotsScreen> {
  final List<_EditableMealSlot> _slots = [];
  final Set<String> _deletedSlotIds = {};
  bool _loading = true;
  bool _saving = false;
  bool _loadFailed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    for (final slot in _slots) {
      slot.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final slots = await ref.read(mealSlotRepositoryProvider).allMealSlots();
      if (!mounted) return;
      setState(() {
        _replaceSlots(slots);
        _loading = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _loadFailed = true;
        _loading = false;
      });
    }
  }

  void _replaceSlots(List<MealSlot> slots) {
    for (final slot in _slots) {
      slot.dispose();
    }
    _slots
      ..clear()
      ..addAll(slots.map(_EditableMealSlot.fromMealSlot));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final normalized = _normalizedSlots(l10n);
    if (normalized == null) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final repository = ref.read(mealSlotRepositoryProvider);
      for (final id in _deletedSlotIds) {
        await repository.deleteMealSlot(id);
      }
      for (final slot in normalized) {
        await repository.saveMealSlot(slot);
      }
      ref.invalidate(mealSlotsProvider);
      if (!mounted) return;
      await Navigator.of(context).maybePop();
      if (!mounted) return;
      setState(() => _saving = false);
    } on Object {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.mealSlotsSaveError;
      });
    }
  }

  List<MealSlot>? _normalizedSlots(AppLocalizations l10n) {
    final seenNames = <String>{};
    final normalized = <MealSlot>[];
    for (var position = 0; position < _slots.length; position++) {
      final slot = _slots[position];
      final name = slot.controller.text.trim();
      if (name.isEmpty) {
        setState(() => _error = l10n.mealSlotNameRequired);
        return null;
      }
      final normalizedName = name.toLowerCase();
      if (!seenNames.add(normalizedName)) {
        setState(() => _error = l10n.mealSlotNamesUnique);
        return null;
      }
      normalized.add(MealSlot(id: slot.id, name: name, position: position));
    }
    return normalized;
  }

  Future<void> _addSlot() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _AddMealSlotDialog(),
    );
    if (name == null || !mounted) return;
    final id = ref.read(idGeneratorProvider).newId();
    setState(() {
      _error = null;
      _slots.add(
        _EditableMealSlot(
          id: id,
          controller: TextEditingController(text: name),
        ),
      );
    });
  }

  Future<void> _removeSlot(_EditableMealSlot slot) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.mealSlotRemoveTitle),
        content: Text(l10n.mealSlotRemoveMessage(slot.controller.text.trim())),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            key: const Key('meal-slot-remove-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.mealSlotRemoveConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _error = null;
      _deletedSlotIds.add(slot.id);
      _slots.remove(slot);
      slot.dispose();
    });
  }

  void _moveSlot(int from, int to) {
    if (to < 0 || to >= _slots.length || from == to) return;
    setState(() {
      _error = null;
      final slot = _slots.removeAt(from);
      _slots.insert(to, slot);
    });
  }

  void _resetToDefault(AppLocalizations l10n) {
    final defaults = DefaultMealSlots.build(
      localizedName: (kind) => _defaultName(l10n, kind),
      idGenerator: ref.read(idGeneratorProvider),
    );
    setState(() {
      _error = null;
      _deletedSlotIds.addAll(_slots.map((slot) => slot.id));
      _replaceSlots(defaults);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mealSlotsTitle),
        actions: [
          TextButton(
            key: const Key('meal-slots-save'),
            onPressed: _loading || _loadFailed || _saving ? null : _save,
            child: Text(l10n.actionSave),
          ),
        ],
      ),
      body: _body(l10n),
    );
  }

  Widget _body(AppLocalizations l10n) {
    if (_loading) return const SizedBox.shrink();
    if (_loadFailed) return Center(child: Text(l10n.mealSlotsLoadError));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (_slots.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(l10n.mealSlotsEmpty),
          )
        else
          for (var index = 0; index < _slots.length; index++)
            _MealSlotRow(
              slot: _slots[index],
              index: index,
              isFirst: index == 0,
              isLast: index == _slots.length - 1,
              onMoveUp: () => _moveSlot(index, index - 1),
              onMoveDown: () => _moveSlot(index, index + 1),
              onRemove: () => _removeSlot(_slots[index]),
            ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addSlot,
          icon: const Icon(Icons.add),
          label: Text(l10n.mealSlotsAdd),
        ),
        TextButton.icon(
          onPressed: () => _resetToDefault(l10n),
          icon: const Icon(Icons.restart_alt),
          label: Text(l10n.mealSlotsResetDefault),
        ),
      ],
    );
  }

  static String _defaultName(
    AppLocalizations l10n,
    DefaultMealSlotKind kind,
  ) => switch (kind) {
    DefaultMealSlotKind.breakfast => l10n.mealBreakfast,
    DefaultMealSlotKind.lunch => l10n.mealLunch,
    DefaultMealSlotKind.dinner => l10n.mealDinner,
    DefaultMealSlotKind.snacks => l10n.mealSnacks,
  };
}

class _MealSlotRow extends StatelessWidget {
  const _MealSlotRow({
    required this.slot,
    required this.index,
    required this.isFirst,
    required this.isLast,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
  });

  final _EditableMealSlot slot;
  final int index;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      key: Key('meal-slot-row-${slot.id}'),
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.drag_handle),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: Key('meal-slot-name-${slot.id}'),
              controller: slot.controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: l10n.mealSlotNameLabel),
            ),
          ),
          IconButton(
            key: Key('meal-slot-move-up-${slot.id}'),
            onPressed: isFirst ? null : onMoveUp,
            tooltip: l10n.mealSlotMoveUp,
            icon: const Icon(Icons.keyboard_arrow_up),
          ),
          IconButton(
            key: Key('meal-slot-move-down-${slot.id}'),
            onPressed: isLast ? null : onMoveDown,
            tooltip: l10n.mealSlotMoveDown,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
          IconButton(
            key: Key('meal-slot-delete-${slot.id}'),
            onPressed: onRemove,
            tooltip: l10n.mealSlotDelete,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _AddMealSlotDialog extends StatefulWidget {
  const _AddMealSlotDialog();

  @override
  State<_AddMealSlotDialog> createState() => _AddMealSlotDialogState();
}

class _AddMealSlotDialogState extends State<_AddMealSlotDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.mealSlotNameRequired);
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.mealSlotsAddDialogTitle),
      content: TextField(
        key: const Key('meal-slot-dialog-name'),
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.mealSlotNameLabel,
          errorText: _error,
        ),
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          key: const Key('meal-slot-dialog-save'),
          onPressed: _save,
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}

class _EditableMealSlot {
  _EditableMealSlot({required this.id, required this.controller});

  factory _EditableMealSlot.fromMealSlot(MealSlot slot) => _EditableMealSlot(
    id: slot.id,
    controller: TextEditingController(text: slot.name),
  );

  final String id;
  final TextEditingController controller;

  void dispose() => controller.dispose();
}
