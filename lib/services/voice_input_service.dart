import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The native bridge only creates Android's on-device recognizer (API 31+).
/// Missing models or unsupported devices fail closed to manual categories.
class VoiceInputService {
  static const _methods = MethodChannel('focum/speech');
  static const _events = EventChannel('focum/speech_events');
  StreamSubscription<dynamic>? _subscription;
  Timer? _timeout;
  bool _isListening = false;
  bool get isListening => _isListening;

  Future<bool> startListening({
    required ValueChanged<String> onText,
    required ValueChanged<String> onFinalText,
    required ValueChanged<bool> onListeningChanged,
    required ValueChanged<double> onSoundLevelChanged,
    required ValueChanged<String> onError,
  }) async {
    await stop();
    void finish() {
      _timeout?.cancel();
      _isListening = false;
      onListeningChanged(false);
    }

    _subscription = _events.receiveBroadcastStream().listen(
      (dynamic raw) {
        final event = Map<String, dynamic>.from(raw as Map);
        if (event['level'] case final num level) {
          onSoundLevelChanged(level.toDouble());
        }
        if (event['text'] case final String text) {
          onText(text);
          if (event['final'] == true) {
            onFinalText(text);
            finish();
          }
        }
        if (event['error'] case final String error) {
          finish();
          onError(error);
        }
      },
      onError: (Object error) {
        finish();
        onError('speech_unavailable');
      },
    );
    try {
      _isListening = await _methods.invokeMethod<bool>('start') ?? false;
    } on PlatformException {
      _isListening = false;
    } on MissingPluginException {
      _isListening = false;
    }
    if (!_isListening) {
      await stop();
      return false;
    }
    onListeningChanged(true);
    _timeout = Timer(const Duration(seconds: 45), () {
      unawaited(stop());
      finish();
    });
    return true;
  }

  Future<void> stop() async {
    _timeout?.cancel();
    _timeout = null;
    _isListening = false;
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _methods.invokeMethod<void>('stop');
    } on MissingPluginException {
      // Unsupported platforms have no voice bridge and remain in manual mode.
    }
  }
}

/// Match installed recognition languages; let the OS choose if none match.
String? resolveSpeechLocale(List<Locale> preferred, List<String> available) {
  String normalize(String value) => value.replaceAll('_', '-').toLowerCase();
  for (final locale in preferred) {
    final tag = normalize(locale.toLanguageTag());
    for (final candidate in available) {
      if (normalize(candidate) == tag) return candidate;
    }
    for (final candidate in available) {
      if (normalize(candidate).split('-').first == locale.languageCode) {
        return candidate;
      }
    }
  }
  return null;
}
