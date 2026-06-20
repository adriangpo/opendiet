import 'package:flutter/material.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/units/unit_conversions.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// An amount input paired with a unit toggle (servings vs g/ml) that emits a
/// canonical-metric [Quantity] (see .spec/design/ui/design-system.md, FR-024).
///
/// The toggle and the entered amount are shown in the user's [unitSystem]; the
/// value handed to [onChanged] is always converted back to canonical metric so
/// the rest of the app only ever stores metric (grams/milliliters). Servings
/// are a count of the food's own serving and are never unit-converted.
///
/// [onChanged] receives null while the amount is empty, non-numeric, or
/// negative so a host form can treat those as "no quantity yet".
class QuantityField extends StatefulWidget {
  /// Creates a quantity field.
  const QuantityField({
    required this.unitSystem,
    required this.onChanged,
    this.hasServingSize = false,
    this.initialValue,
    super.key,
  });

  /// The unit system the amount is entered and displayed in.
  final UnitSystem unitSystem;

  /// Called with the canonical-metric quantity, or null when input is invalid.
  final ValueChanged<Quantity?> onChanged;

  /// Whether the food defines a serving size; when false the servings option
  /// is hidden (FR-003).
  final bool hasServingSize;

  /// An optional starting quantity (canonical metric) to prefill and select.
  final Quantity? initialValue;

  @override
  State<QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<QuantityField> {
  late final TextEditingController _controller;
  late QuantityMeasure _measure;

  List<QuantityMeasure> get _measures => [
    if (widget.hasServingSize) QuantityMeasure.servings,
    QuantityMeasure.grams,
    QuantityMeasure.milliliters,
  ];

  @override
  void initState() {
    super.initState();
    final initialMeasure = widget.initialValue?.measure;
    _measure = (initialMeasure != null && _measures.contains(initialMeasure))
        ? initialMeasure
        : _measures.first;
    _controller = TextEditingController(
      text: widget.initialValue == null
          ? ''
          : _formatAmount(_displayAmount(widget.initialValue!)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Converts a canonical-metric [quantity] to the amount shown in the field.
  double _displayAmount(Quantity quantity) => switch (quantity.measure) {
    QuantityMeasure.servings => quantity.amount,
    QuantityMeasure.grams => MassConverter.fromGrams(
      quantity.amount,
      widget.unitSystem.massUnit,
    ),
    QuantityMeasure.milliliters => VolumeConverter.fromMilliliters(
      quantity.amount,
      widget.unitSystem.volumeUnit,
    ),
  };

  /// Builds a canonical-metric quantity from a display [value] in [_measure].
  Quantity _toCanonical(double value) => switch (_measure) {
    QuantityMeasure.servings => Quantity.servings(value),
    QuantityMeasure.grams => Quantity.grams(
      MassConverter.toGrams(value, widget.unitSystem.massUnit),
    ),
    QuantityMeasure.milliliters => Quantity.milliliters(
      VolumeConverter.toMilliliters(value, widget.unitSystem.volumeUnit),
    ),
  };

  void _emit() {
    final value = double.tryParse(_controller.text.trim().replaceAll(',', '.'));
    widget.onChanged(value == null || value < 0 ? null : _toCanonical(value));
  }

  String _unitLabel(AppLocalizations l10n, QuantityMeasure measure) {
    final metric = widget.unitSystem == UnitSystem.metric;
    return switch (measure) {
      QuantityMeasure.servings => l10n.quantityUnitServings,
      QuantityMeasure.grams => metric ? l10n.unitGram : l10n.unitOunce,
      QuantityMeasure.milliliters =>
        metric ? l10n.unitMilliliter : l10n.unitFluidOunce,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('quantity-amount'),
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => _emit(),
          decoration: InputDecoration(labelText: l10n.quantityFieldAmount),
        ),
        const SizedBox(height: 8),
        SegmentedButton<QuantityMeasure>(
          segments: [
            for (final measure in _measures)
              ButtonSegment(
                value: measure,
                label: Text(_unitLabel(l10n, measure)),
              ),
          ],
          selected: {_measure},
          onSelectionChanged: (selection) {
            setState(() => _measure = selection.single);
            _emit();
          },
        ),
      ],
    );
  }
}

/// Formats a display amount, dropping a redundant trailing fraction.
String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}
