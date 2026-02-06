import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:ui';
import 'local_storage_service.dart';

class VoiceGuideService extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isAccessibilityModeEnabled = false;
  final LocalStorageService _storage;

  bool get isAccessibilityModeEnabled => _isAccessibilityModeEnabled;

  VoiceGuideService(this._storage) {
    _initTts();
    _loadAccessibilityMode();
  }

  Future<void> _initTts() async {
 await _flutterTts.setLanguage("am-ET"); // Amharic (Ethiopia)

  await _flutterTts.setVolume(1.0);       // Max volume
  await _flutterTts.setSpeechRate(0.4);   // Best for Amharic clarity
  await _flutterTts.setPitch(1.0);        // Natural human voice

  await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _loadAccessibilityMode() async {
    _isAccessibilityModeEnabled = _storage.getBool('voice_accessibility_mode') ?? false;
    notifyListeners();
  }

  Future<void> setAccessibilityMode(bool enabled) async {
    _isAccessibilityModeEnabled = enabled;
    await _storage.setBool('voice_accessibility_mode', enabled);
    notifyListeners();
  }

  Future<void> speakQueue(List<String> messages, Locale locale) async {
    await stop(); 
    for (var message in messages) {
      await speak(message, locale);
    }
  }

  Future<void> speak(String text, Locale locale) async {
    String languageCode = locale.languageCode;
    
    String ttsLanguage;
    switch (languageCode) {
      case 'am':
        ttsLanguage = 'am-ET';
        break;
      case 'om':
        ttsLanguage = 'om-ET';
        break;
      case 'en':
      default:
        ttsLanguage = 'en-US';
        break;
    }

    bool isLanguageAvailable = await _flutterTts.isLanguageAvailable(ttsLanguage);
    
    if (isLanguageAvailable) {
      await _flutterTts.setLanguage(ttsLanguage);
    } else {
      await _flutterTts.setLanguage(languageCode);
    }

    if (languageCode == 'am') {
      await _flutterTts.setSpeechRate(0.4); // Slower for Amharic
    } else {
      await _flutterTts.setSpeechRate(0.5); // Default for others
    }

    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
