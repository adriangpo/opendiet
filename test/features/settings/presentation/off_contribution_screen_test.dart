import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/foods/data/off_account_providers.dart';
import 'package:opendiet/features/foods/data/off_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/off_account.dart';
import 'package:opendiet/features/foods/domain/off_account_repository.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';
import 'package:opendiet/features/settings/presentation/off_contribution_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/test_app.dart';

void main() {
  testWidgets('signed-out state blocks contribution form', (tester) async {
    await pumpApp(
      tester,
      const OffContributionScreen(mode: OffContributionMode.addProduct),
      overrides: [
        offAccountRepositoryProvider.overrideWithValue(
          _FakeOffAccountRepository(),
        ),
        offRepositoryProvider.overrideWithValue(_FakeOffRepository()),
      ],
    );

    expect(find.text('Sign in to contribute products.'), findsOneWidget);
    expect(find.text('Submit'), findsNothing);
  });

  testWidgets('submits a new product through the OFF repository', (
    tester,
  ) async {
    final offRepository = _FakeOffRepository();
    await pumpApp(
      tester,
      const OffContributionScreen(mode: OffContributionMode.addProduct),
      overrides: _overrides(offRepository),
    );

    await tester.enterText(find.byKey(const Key('off-product-name')), 'Oats');
    await tester.enterText(find.byKey(const Key('off-brand')), 'OpenDiet');
    await tester.enterText(find.byKey(const Key('off-barcode')), '123');
    await tester.tap(find.text('Submit'));
    await tester.pump();
    await tester.pump();

    expect(offRepository.savedProducts.single.name, 'Oats');
    expect(offRepository.savedProducts.single.brand, 'OpenDiet');
    expect(offRepository.savedProducts.single.barcode, '123');
    expect(offRepository.savedProducts.single.source, FoodSource.openFoodFacts);
    expect(find.text('Contribution submitted.'), findsOneWidget);
  });

  testWidgets('invalid contribution keeps the form local', (tester) async {
    final offRepository = _FakeOffRepository();
    await pumpApp(
      tester,
      const OffContributionScreen(mode: OffContributionMode.addProduct),
      overrides: _overrides(offRepository),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Enter a product name'), findsOneWidget);
    expect(offRepository.savedProducts, isEmpty);
  });

  testWidgets('failed contribution keeps entered data', (tester) async {
    final offRepository = _FakeOffRepository()..failSaves = true;
    await pumpApp(
      tester,
      const OffContributionScreen(mode: OffContributionMode.suggestCorrection),
      overrides: _overrides(offRepository),
    );

    await tester.enterText(find.byKey(const Key('off-product-name')), 'Oats');
    await tester.enterText(find.byKey(const Key('off-barcode')), '123');
    await tester.tap(find.text('Submit'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('Could not submit. Your product details are still here.'),
      findsOneWidget,
    );
    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('123'), findsOneWidget);
  });
}

List<Override> _overrides(_FakeOffRepository offRepository) => [
  offAccountRepositoryProvider.overrideWithValue(
    _FakeOffAccountRepository(account: const OffAccount(userId: 'alice')),
  ),
  offRepositoryProvider.overrideWithValue(offRepository),
  idGeneratorProvider.overrideWithValue(const _FixedIdGenerator()),
  clockProvider.overrideWithValue(const _FixedClock()),
];

class _FakeOffAccountRepository implements OffAccountRepository {
  _FakeOffAccountRepository({this.account});

  OffAccount? account;

  @override
  Future<OffAccount?> loadAccount() async => account;

  @override
  Future<OffAccount> signIn({
    required String userId,
    required String password,
  }) async {
    account = OffAccount(userId: userId);
    return account!;
  }

  @override
  Future<void> signOut() async {
    account = null;
  }
}

class _FakeOffRepository implements OffRepository {
  final List<Food> savedProducts = [];
  bool failSaves = false;

  @override
  void clearCredentials() {}

  @override
  Future<OffBarcodeResult> getProductByBarcode(String barcode) async =>
      const OffBarcodeNotFound();

  @override
  Future<bool> login(String userId, String password) async => true;

  @override
  void restoreCredentials(String userId, String password) {}

  @override
  Future<void> saveProduct(Food food) async {
    if (failSaves) throw Exception('offline');
    savedProducts.add(food);
  }

  @override
  Future<OffSearchResult> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 25,
  }) async => OffSearchResult(products: const [], totalCount: 0);
}

class _FixedIdGenerator implements IdGenerator {
  const _FixedIdGenerator();

  @override
  String newId() => 'fixed-id';
}

class _FixedClock implements Clock {
  const _FixedClock();

  @override
  DateTime now() => DateTime(2026);
}
