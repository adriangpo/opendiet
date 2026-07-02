import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/presentation/diary_entry_row.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_diary_repository.dart';
import '../../../support/test_app.dart';

/// Pumps a single [DiaryEntryRow] with required ancestors.
Future<void> pumpEntryRow(
  WidgetTester tester, {
  required DiaryEntry entry,
  required VoidCallback onTap,
  required Future<void> Function() onDelete,
  List<Override> overrides = const [],
}) async {
  final allOverrides = <Override>[
    diaryRepositoryProvider.overrideWithValue(FakeDiaryRepository()),
    ...overrides,
  ];
  await pumpApp(
    tester,
    Builder(
      builder: (context) => Scaffold(
        body: DiaryEntryRow(
          entry: entry,
          onTap: onTap,
          onDelete: onDelete,
        ),
      ),
    ),
    overrides: allOverrides,
  );
}

void main() {
  final baseEntry = DiaryEntry(
    id: 'e1',
    day: DateTime.utc(2026, 6, 20),
    mealSlotId: 's1',
    referenceKind: DiaryReferenceKind.food,
    referenceId: 'f1',
    label: 'Oats',
    quantity: Quantity.grams(100),
    nutrients: const Nutrients(energyKcal: 180),
    loggedAt: DateTime.utc(2026, 6, 20, 8),
  );

  group('DiaryEntryRow - display', () {
    testWidgets('shows entry label and kcal', (tester) async {
      await pumpEntryRow(
        tester,
        entry: baseEntry,
        onTap: () {},
        onDelete: () async {},
      );

      expect(find.text('Oats'), findsOneWidget);
      expect(find.textContaining('180'), findsOneWidget);
    });

    testWidgets('shows "--" when kcal is null', (tester) async {
      await pumpEntryRow(
        tester,
        entry: baseEntry.copyWith(
          nutrients: Nutrients.empty,
        ),
        onTap: () {},
        onDelete: () async {},
      );

      expect(find.text('Oats'), findsOneWidget);
      expect(find.text('--'), findsOneWidget);
    });

    testWidgets('shows label in title', (tester) async {
      await pumpEntryRow(
        tester,
        entry: baseEntry.copyWith(
          label: 'Oats, 1 bowl (250 g)',
        ),
        onTap: () {},
        onDelete: () async {},
      );

      expect(find.text('Oats, 1 bowl (250 g)'), findsOneWidget);
    });
  });

  group('DiaryEntryRow - interactions', () {
    testWidgets('tapping calls onTap callback', (tester) async {
      var tapped = false;
      await pumpEntryRow(
        tester,
        entry: baseEntry,
        onTap: () => tapped = true,
        onDelete: () async {},
      );

      await tester.tap(find.text('Oats'));
      expect(tapped, isTrue);
    });

    testWidgets('swipe shows confirmation dialog', (tester) async {
      await pumpEntryRow(
        tester,
        entry: baseEntry,
        onTap: () {},
        onDelete: () async {},
      );

      final dismissible = find.byKey(const ValueKey('e1'));
      await tester.timedDrag(
        dismissible,
        const Offset(-800, 0),
        const Duration(milliseconds: 500),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Remove entry'), findsOneWidget);
      expect(find.text('Remove Oats?'), findsOneWidget);
    });

    testWidgets('confirming delete calls onDelete callback', (tester) async {
      var deleted = false;
      await pumpEntryRow(
        tester,
        entry: baseEntry,
        onTap: () {},
        onDelete: () async => deleted = true,
      );

      final dismissible = find.byKey(const ValueKey('e1'));
      await tester.timedDrag(
        dismissible,
        const Offset(-800, 0),
        const Duration(milliseconds: 500),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    });

    testWidgets('canceling delete does NOT call onDelete', (tester) async {
      var deleted = false;
      await pumpEntryRow(
        tester,
        entry: baseEntry,
        onTap: () {},
        onDelete: () async => deleted = true,
      );

      final dismissible = find.byKey(const ValueKey('e1'));
      await tester.timedDrag(
        dismissible,
        const Offset(-800, 0),
        const Duration(milliseconds: 500),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(deleted, isFalse);
    });
  });
}
