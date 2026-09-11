import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/app_user.dart';
import '../../data/services/app_storage.dart';
import '../../data/services/youtube_service.dart';

class AuthProvider extends ChangeNotifier {
  final AppStorage storage;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'openid', 'profile'],
  );
  final GoogleSignIn _youtubeSignIn = GoogleSignIn(
    scopes: [
      'email',
      'openid',
      'profile',
      'https://www.googleapis.com/auth/youtube',
    ],
  );

  AppUser? _user;
  bool _loading = false;
  bool _youtubeLoading = false;
  YouTubeChannel? _youtubeChannel;
  String? _youtubeError;

  AuthProvider(this.storage) {
    _user = storage.user;
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get loading => _loading;
  bool get youtubeLoading => _youtubeLoading;
  YouTubeChannel? get youtubeChannel => _youtubeChannel;
  String? get youtubeError => _youtubeError;

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

  Future<void> connectYouTube() async {
    _youtubeLoading = true;
    _youtubeError = null;
    notifyListeners();
    try {
      final account = await _youtubeSignIn.signIn();
      if (account == null) {
        throw const YouTubeApiException('YouTube connection was cancelled.');
      }
      final authentication = await account.authentication;
      final token = authentication.accessToken;
      if (token == null || token.isEmpty) {
        throw const YouTubeApiException('Google did not return a YouTube access token.');
      }
      _youtubeChannel = await YouTubeService(accessToken: token).fetchMyChannel();
    } on YouTubeApiException catch (error) {
      _youtubeError = error.message;
    } catch (_) {
      _youtubeError = 'Unable to connect YouTube. Check the Google OAuth setup and try again.';
    } finally {
      _youtubeLoading = false;
      notifyListeners();
    }
  }

  Future<void> disconnectYouTube() async {
    await _youtubeSignIn.signOut();
    _youtubeChannel = null;
    _youtubeError = null;
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
    _youtubeChannel = null;
    await storage.clearUser();
    try {
      await _googleSignIn.signOut();
      await _youtubeSignIn.signOut();
    } catch (_) {}
    notifyListeners();
  }
}
