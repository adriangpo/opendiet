import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// A searchable dialog that lets the user pick a food from the local catalog.
///
/// Returns the selected [Food] via [Navigator.pop].
class FoodPickerDialog extends ConsumerStatefulWidget {
  /// Creates a food picker dialog.
  const FoodPickerDialog({super.key});

  /// Shows the dialog and returns the selected food, or null if cancelled.
  static Future<Food?> show(BuildContext context) => showDialog<Food>(
    context: context,
    builder: (_) => const FoodPickerDialog(),
  );

  @override
  ConsumerState<FoodPickerDialog> createState() => _FoodPickerDialogState();
}

class _FoodPickerDialogState extends ConsumerState<FoodPickerDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final foodsAsync = ref.watch(foodListProvider);

    return AlertDialog(
      title: Text(l10n.foodPickerTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('food-picker-search-field'),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.foodPickerSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) =>
                  setState(() => _query = value.toLowerCase()),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: foodsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (foods) {
                  final filtered = _query.isEmpty
                      ? foods
                      : foods
                            .where((f) => f.name.toLowerCase().contains(_query))
                            .toList();
                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(l10n.foodPickerEmpty),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(filtered[index].name),
                      subtitle: filtered[index].brand != null
                          ? Text(filtered[index].brand!)
                          : null,
                      onTap: () => Navigator.pop(context, filtered[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            MaterialLocalizations.of(context).cancelButtonLabel,
          ),
        ),
      ],
    );
  }
}
