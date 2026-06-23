import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/features/foods/domain/off_account.dart';
import 'package:opendiet/features/settings/presentation/off_account_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Open Food Facts account and contribution hub (S-17).
class OffAccountScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const OffAccountScreen({super.key});

  @override
  ConsumerState<OffAccountScreen> createState() => _OffAccountScreenState();
}

class _OffAccountScreenState extends ConsumerState<OffAccountScreen> {
  final TextEditingController _userId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isSigningIn = false;
  String? _error;

  @override
  void dispose() {
    _userId.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final account = ref.watch(offAccountControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.offAccountTitle)),
      body: switch (account) {
        AsyncData(:final value) =>
          value == null
              ? _SignedOutAccountForm(
                  userId: _userId,
                  password: _password,
                  isSigningIn: _isSigningIn,
                  error: _error,
                  onSignIn: _signIn,
                )
              : _SignedInAccount(account: value),
        AsyncError() => Center(child: Text(l10n.offAccountLoadError)),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Future<void> _signIn() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isSigningIn = true;
      _error = null;
    });
    try {
      await ref
          .read(offAccountControllerProvider.notifier)
          .signIn(
            userId: _userId.text,
            password: _password.text,
          );
    } on OffSignInException {
      if (!mounted) return;
      setState(() => _error = l10n.offAccountSignInFailed);
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }
}

class _SignedOutAccountForm extends StatelessWidget {
  const _SignedOutAccountForm({
    required this.userId,
    required this.password,
    required this.isSigningIn,
    required this.error,
    required this.onSignIn,
  });

  final TextEditingController userId;
  final TextEditingController password;
  final bool isSigningIn;
  final String? error;
  final Future<void> Function() onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.offAccountSignedOutStatus),
        const SizedBox(height: 8),
        Text(l10n.offAccountSignInHelp),
        const SizedBox(height: 16),
        TextFormField(
          controller: userId,
          decoration: InputDecoration(labelText: l10n.offAccountUsername),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: password,
          decoration: InputDecoration(labelText: l10n.offAccountPassword),
          obscureText: true,
          onFieldSubmitted: (_) => unawaited(onSignIn()),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(
            error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: isSigningIn ? null : () => unawaited(onSignIn()),
            child: Text(l10n.offAccountSignInAction),
          ),
        ),
      ],
    );
  }
}

class _SignedInAccount extends ConsumerWidget {
  const _SignedInAccount({required this.account});

  final OffAccount account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.offAccountSignedIn(account.userId)),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.push('/settings/open-food-facts/add'),
          child: Text(l10n.offContributionAddProduct),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => context.push('/settings/open-food-facts/correction'),
          child: Text(l10n.offContributionSuggestCorrection),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => unawaited(
            ref.read(offAccountControllerProvider.notifier).signOut(),
          ),
          child: Text(l10n.offAccountSignOutAction),
        ),
      ],
    );
  }
}
