import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  static const String _onboardingKey = 'onboarding_completed';
  bool _isOnboardingCompleted = false;
  late SharedPreferences _prefs;
  bool _initialized = false;

  bool get isOnboardingCompleted => _isOnboardingCompleted;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isOnboardingCompleted = _prefs.getBool(_onboardingKey) ?? false;
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    // Ensure prefs is initialized
    if (!_initialized) {
      await init();
    }
    _isOnboardingCompleted = true;
    await _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    if (!_initialized) {
      await init();
    }
    _isOnboardingCompleted = false;
    await _prefs.setBool(_onboardingKey, false);
    notifyListeners();
  }
}
