import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/data/off_account_repository.dart';
import 'package:opendiet/features/foods/data/off_credential_store.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/off_account.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';

void main() {
  group('SecureOffAccountRepository', () {
    late _FakeOffCredentialStore store;
    late _FakeOffRepository offRepository;
    late SecureOffAccountRepository repository;

    setUp(() {
      store = _FakeOffCredentialStore();
      offRepository = _FakeOffRepository();
      repository = SecureOffAccountRepository(
        credentials: store,
        offRepository: offRepository,
      );
    });

    test(
      'returns null and clears OFF auth when secure storage is empty',
      () async {
        final account = await repository.loadAccount();

        expect(account, isNull);
        expect(offRepository.clearedCredentials, isTrue);
        expect(offRepository.loginAttempts, isEmpty);
      },
    );

    test(
      'restores saved credentials without calling the live login API',
      () async {
        store.credentials = const OffStoredCredentials(
          userId: 'alice',
          password: 'secret',
        );

        final account = await repository.loadAccount();

        expect(account?.userId, 'alice');
        expect(offRepository.loginAttempts, isEmpty);
        expect(offRepository.restoredUserId, 'alice');
        expect(offRepository.restoredPassword, 'secret');
      },
    );

    test('persists accepted credentials in secure storage', () async {
      offRepository.acceptedCredentials.add(('alice', 'secret'));

      final account = await repository.signIn(
        userId: ' alice ',
        password: 'secret',
      );

      expect(account.userId, 'alice');
      expect(store.credentials?.userId, 'alice');
      expect(store.credentials?.password, 'secret');
      expect(offRepository.loginAttempts, [('alice', 'secret')]);
    });

    test('rejects empty credentials without writing secure storage', () async {
      await expectLater(
        repository.signIn(userId: ' ', password: 'secret'),
        throwsA(isA<OffSignInException>()),
      );
      await expectLater(
        repository.signIn(userId: 'alice', password: ''),
        throwsA(isA<OffSignInException>()),
      );

      expect(store.credentials, isNull);
      expect(offRepository.loginAttempts, isEmpty);
    });

    test('does not persist rejected credentials', () async {
      await expectLater(
        repository.signIn(userId: 'alice', password: 'wrong'),
        throwsA(isA<OffSignInException>()),
      );

      expect(store.credentials, isNull);
      expect(offRepository.loginAttempts, [('alice', 'wrong')]);
    });

    test(
      'signs out by deleting secure storage and clearing OFF auth',
      () async {
        store.credentials = const OffStoredCredentials(
          userId: 'alice',
          password: 'secret',
        );

        await repository.signOut();

        expect(store.credentials, isNull);
        expect(offRepository.clearedCredentials, isTrue);
      },
    );
  });
}

class _FakeOffCredentialStore implements OffCredentialStore {
  OffStoredCredentials? credentials;

  @override
  Future<OffStoredCredentials?> read() async => credentials;

  @override
  Future<void> write(OffStoredCredentials credentials) async {
    this.credentials = credentials;
  }

  @override
  Future<void> delete() async {
    credentials = null;
  }
}

class _FakeOffRepository implements OffRepository {
  final Set<(String, String)> acceptedCredentials = {};
  final List<(String, String)> loginAttempts = [];
  bool clearedCredentials = false;
  String? restoredUserId;
  String? restoredPassword;

  @override
  void clearCredentials() {
    clearedCredentials = true;
    restoredUserId = null;
    restoredPassword = null;
  }

  @override
  Future<OffBarcodeResult> getProductByBarcode(String barcode) async =>
      const OffBarcodeNotFound();

  @override
  Future<bool> login(String userId, String password) async {
    loginAttempts.add((userId, password));
    return acceptedCredentials.contains((userId, password));
  }

  @override
  void restoreCredentials(String userId, String password) {
    restoredUserId = userId;
    restoredPassword = password;
  }

  @override
  Future<void> saveProduct(Food food) async {}

  @override
  Future<OffSearchResult> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 25,
  }) async => OffSearchResult(products: const [], totalCount: 0);
}
