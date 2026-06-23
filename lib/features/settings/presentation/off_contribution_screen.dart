import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/foods/data/off_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/settings/presentation/off_account_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// OFF contribution screen mode.
enum OffContributionMode {
  /// Submit a new product.
  addProduct,

  /// Suggest a correction to an existing product.
  suggestCorrection,
}

/// Minimal product contribution form (FR-012).
class OffContributionScreen extends ConsumerStatefulWidget {
  /// Creates the contribution screen.
  const OffContributionScreen({required this.mode, super.key});

  /// The contribution mode.
  final OffContributionMode mode;

  @override
  ConsumerState<OffContributionScreen> createState() =>
      _OffContributionScreenState();
}

class _OffContributionScreenState extends ConsumerState<OffContributionScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _barcode = TextEditingController();
  String? _message;
  bool _isError = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _name.dispose();
    _brand.dispose();
    _barcode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final account = ref.watch(offAccountControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(_title(l10n))),
      body: switch (account) {
        AsyncData(:final value) =>
          value == null
              ? Center(child: Text(l10n.offAccountSignInHelp))
              : _buildForm(l10n),
        AsyncError() => Center(child: Text(l10n.offAccountLoadError)),
        _ => const SizedBox.shrink(),
      },
    );
  }

  String _title(AppLocalizations l10n) => switch (widget.mode) {
    OffContributionMode.addProduct => l10n.offContributionAddProduct,
    OffContributionMode.suggestCorrection =>
      l10n.offContributionSuggestCorrection,
  };

  Widget _buildForm(AppLocalizations l10n) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      if (_message != null) ...[
        Text(
          _message!,
          style: TextStyle(
            color: _isError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
      ],
      TextField(
        key: const Key('off-product-name'),
        controller: _name,
        decoration: InputDecoration(labelText: l10n.offProductName),
      ),
      const SizedBox(height: 12),
      TextField(
        key: const Key('off-brand'),
        controller: _brand,
        decoration: InputDecoration(labelText: l10n.foodFieldBrand),
      ),
      const SizedBox(height: 12),
      TextField(
        key: const Key('off-barcode'),
        controller: _barcode,
        decoration: InputDecoration(labelText: l10n.foodFieldBarcode),
      ),
      const SizedBox(height: 16),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton(
          onPressed: _isSubmitting ? null : () => unawaited(_submit(l10n)),
          child: Text(l10n.offContributionSubmit),
        ),
      ),
    ],
  );

  Future<void> _submit(AppLocalizations l10n) async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() {
        _message = l10n.offContributionNameRequired;
        _isError = true;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = null;
      _isError = false;
    });
    try {
      final now = ref.read(clockProvider).now();
      final food = Food(
        id: ref.read(idGeneratorProvider).newId(),
        name: name,
        brand: _trimToNull(_brand.text),
        barcode: _trimToNull(_barcode.text),
        source: FoodSource.openFoodFacts,
        basis: NutrientBasis.per100g,
        nutrients: Nutrients.empty,
        createdAt: now,
        updatedAt: now,
      );
      await ref.read(offRepositoryProvider).saveProduct(food);
      if (!mounted) return;
      setState(() {
        _message = l10n.offContributionSubmitted;
        _isError = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _message = l10n.offContributionSubmitFailed;
        _isError = true;
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _trimToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
