import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/app_user.dart';
import '../../data/services/app_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AppStorage storage;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'openid', 'profile'],
  );

  AppUser? _user;
  bool _loading = false;

  AuthProvider(this.storage) {
    _user = storage.user;
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get loading => _loading;

  Future<void> signInWithGoogle() async {
    _loading = true;
    notifyListeners();
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _user = AppUser(
          name: account.displayName ?? 'Creator',
          email: account.email,
          photoUrl: account.photoUrl ?? '',
          isDemo: false,
        );
      }
    } catch (_) {
      // Google Sign-In not configured on this machine yet -> demo fallback
      // so the rest of the app stays testable. See WHATS_NEEDED_TO_ADD.txt.
      _user = const AppUser(
        name: 'Demo Creator',
        email: 'demo@smartyt.app',
        isDemo: true,
      );
    }
    if (_user != null) await storage.saveUser(_user!);
    _loading = false;
    notifyListeners();
  }

  Future<void> continueAsDemo() async {
    _user = const AppUser(
      name: 'Demo Creator',
      email: 'demo@smartyt.app',
      isDemo: true,
    );
    await storage.saveUser(_user!);
    notifyListeners();
  }

  Future<void> signOut() async {
    _user = null;
    await storage.clearUser();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    notifyListeners();
  }
}
