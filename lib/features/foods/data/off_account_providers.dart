import 'package:opendiet/features/foods/data/off_account_repository.dart';
import 'package:opendiet/features/foods/data/off_credential_store.dart';
import 'package:opendiet/features/foods/data/off_providers.dart';
import 'package:opendiet/features/foods/domain/off_account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'off_account_providers.g.dart';

/// Secure credential storage for Open Food Facts account data.
@Riverpod(keepAlive: true)
OffCredentialStore offCredentialStore(Ref ref) =>
    const FlutterSecureOffCredentialStore();

/// Open Food Facts account repository (FR-012, NFR-008).
@Riverpod(keepAlive: true)
OffAccountRepository offAccountRepository(Ref ref) =>
    SecureOffAccountRepository(
      credentials: ref.watch(offCredentialStoreProvider),
      offRepository: ref.watch(offRepositoryProvider),
    );
