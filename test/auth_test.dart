import 'package:flutter_test/flutter_test.dart';
import 'package:thenotes/services/auth/auth_exceptions.dart';
import 'package:thenotes/services/auth/auth_provider.dart';
import 'package:thenotes/services/auth/auth_user.dart';

void main() {
  group('Mock Auth', () {
    final provider = MockAuthProvider();
    test('should not be initialize to begin with',
        () => expect(provider.isInitialized, false));
    test(
        'can not logout if not initialize',
        () => expect(provider.logOut(),
            throwsA(const TypeMatcher<NotInitializedException>())));

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('user should be null upon initialization',
        () => expect(provider.currentUser, null));

    test('should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'password',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser = provider.createUser(
        email: 'email',
        password: '123456',
      );

      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );

      final user = provider.createUser(email: 'email', password: 'password',);

      expect(provider.currentUser, user);
    });
    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('should be able to logout and login again', () async{
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password',);
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == '123456') throw WrongPasswordAuthException();
    await Future.delayed(const Duration(seconds: 1));
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
