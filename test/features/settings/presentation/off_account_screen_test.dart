import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/data/off_account_providers.dart';
import 'package:opendiet/features/foods/domain/off_account.dart';
import 'package:opendiet/features/foods/domain/off_account_repository.dart';
import 'package:opendiet/features/settings/presentation/off_account_screen.dart';

import '../../../support/test_app.dart';

void main() {
  testWidgets('signed-out state hides contribution actions', (tester) async {
    await pumpApp(
      tester,
      const OffAccountScreen(),
      overrides: [
        offAccountRepositoryProvider.overrideWithValue(
          _FakeOffAccountRepository(),
        ),
      ],
    );

    expect(find.text('Status: not signed in'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Add a product'), findsNothing);
    expect(find.text('Suggest a correction'), findsNothing);
    expect(find.text('Sign out'), findsNothing);
  });

  testWidgets('existing secure-storage account exposes contribution actions', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const OffAccountScreen(),
      overrides: [
        offAccountRepositoryProvider.overrideWithValue(
          _FakeOffAccountRepository(account: const OffAccount(userId: 'alice')),
        ),
      ],
    );

    expect(find.text('Signed in: alice'), findsOneWidget);
    expect(find.text('Add a product'), findsOneWidget);
    expect(find.text('Suggest a correction'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('sign-in stores the account and switches to contribution state', (
    tester,
  ) async {
    final repository = _FakeOffAccountRepository()
      ..acceptedUserId = 'alice'
      ..acceptedPassword = 'secret';

    await pumpApp(
      tester,
      const OffAccountScreen(),
      overrides: [
        offAccountRepositoryProvider.overrideWithValue(repository),
      ],
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'alice',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pump();

    expect(repository.account?.userId, 'alice');
    expect(find.text('Signed in: alice'), findsOneWidget);
    expect(find.text('Add a product'), findsOneWidget);
  });

  testWidgets('failed sign-in keeps entered credentials on screen', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const OffAccountScreen(),
      overrides: [
        offAccountRepositoryProvider.overrideWithValue(
          _FakeOffAccountRepository(),
        ),
      ],
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'alice',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'wrong',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('Could not sign in. Check the account and try again.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
    expect(find.text('alice'), findsOneWidget);
    expect(find.text('wrong'), findsOneWidget);
  });

  testWidgets('sign out clears contribution actions', (tester) async {
    final repository = _FakeOffAccountRepository(
      account: const OffAccount(userId: 'alice'),
    );

    await pumpApp(
      tester,
      const OffAccountScreen(),
      overrides: [
        offAccountRepositoryProvider.overrideWithValue(repository),
      ],
    );

    await tester.tap(find.text('Sign out'));
    await tester.pump();
    await tester.pump();

    expect(repository.account, isNull);
    expect(find.text('Status: not signed in'), findsOneWidget);
    expect(find.text('Add a product'), findsNothing);
  });
}

class _FakeOffAccountRepository implements OffAccountRepository {
  _FakeOffAccountRepository({this.account});

  OffAccount? account;
  String? acceptedUserId;
  String? acceptedPassword;

  @override
  Future<OffAccount?> loadAccount() async => account;

  @override
  Future<OffAccount> signIn({
    required String userId,
    required String password,
  }) async {
    if (userId == acceptedUserId && password == acceptedPassword) {
      account = OffAccount(userId: userId);
      return account!;
    }
    throw const OffSignInException();
  }

  @override
  Future<void> signOut() async {
    account = null;
  }
}
