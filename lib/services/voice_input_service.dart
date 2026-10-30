import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceInputService {
  final SpeechToText _speech = SpeechToText();

  bool get isListening => _speech.isListening;

  Future<bool> startListening({
    required ValueChanged<String> onText,
    required ValueChanged<String> onFinalText,
    required ValueChanged<bool> onListeningChanged,
    required ValueChanged<double> onSoundLevelChanged,
    required ValueChanged<String> onError,
  }) async {
    final available = await _speech.initialize(
      onStatus: (status) => _handleStatus(status, onListeningChanged),
      onError: (error) => _handleError(error, onListeningChanged, onError),
    );

    if (!available) {
      return false;
    }

    final installedLocales = await _speech.locales();
    final localeId = resolveSpeechLocale(
      WidgetsBinding.instance.platformDispatcher.locales,
      installedLocales.map((locale) => locale.localeId).toList(),
    );

    await _speech.listen(
      onResult: (result) =>
          _handleResult(result, onText, onFinalText, onListeningChanged),
      onSoundLevelChange: onSoundLevelChanged,
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 45),
        pauseFor: const Duration(seconds: 4),
        localeId: localeId,
        listenMode: ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
      ),
    );

    onListeningChanged(true);
    return true;
  }

  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  void _handleResult(
    SpeechRecognitionResult result,
    ValueChanged<String> onText,
    ValueChanged<String> onFinalText,
    ValueChanged<bool> onListeningChanged,
  ) {
    onText(result.recognizedWords);
    if (result.finalResult) {
      onFinalText(result.recognizedWords);
      onListeningChanged(false);
    }
  }

  void _handleStatus(String status, ValueChanged<bool> onListeningChanged) {
    final normalized = status.toLowerCase();
    if (normalized.contains('listening')) {
      onListeningChanged(true);
      return;
    }

    if (normalized.contains('done') || normalized.contains('notlistening')) {
      onListeningChanged(false);
    }
  }

  void _handleError(
    SpeechRecognitionError error,
    ValueChanged<bool> onListeningChanged,
    ValueChanged<String> onError,
  ) {
    onListeningChanged(false);
    onError(error.errorMsg);
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
