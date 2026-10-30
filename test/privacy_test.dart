import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focum/l10n/l10n.dart';
import 'package:focum/screens/privacy_screen.dart';
import 'package:focum/services/native_focum_service.dart';
import 'package:focum/services/voice_input_service.dart';
import 'package:focum/services/permissions_service.dart';
import 'package:focum/services/intention_repository.dart';
import 'package:focum/services/intention_classifier.dart';
import 'package:focum/state/app_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  test('existing system permissions do not imply privacy consent', () {
    final state = NativeAppState.fromMap({'usageAccessGranted': true});
    expect(state.usageAccessGranted, isTrue);
    expect(state.usageConsent, isFalse);
    expect(state.microphoneConsent, isFalse);
  });

  test(
    'unlocking opens manual mode without requesting or starting the microphone',
    () async {
      final calls = <String>[];
      for (final name in ['focum/native', 'focum/speech']) {
        messenger.setMockMethodCallHandler(MethodChannel(name), (call) async {
          calls.add(call.method);
          return null;
        });
        addTearDown(
          () => messenger.setMockMethodCallHandler(MethodChannel(name), null),
        );
      }
      final native = NativeFocumService();
      final controller = AppController(
        nativeService: native,
        permissionsService: PermissionsService(native),
        repository: IntentionRepository(),
        voiceInputService: VoiceInputService(),
        classifier: IntentionClassifier(),
      );
      controller.showUnlockPrompt(source: PromptSource.unlockMonitor);
      await pumpEventQueue();
      expect(controller.promptVisible, isTrue);
      expect(controller.isVoiceMode, isFalse);
      expect(controller.isListening, isFalse);
      expect(calls, isEmpty);
      controller.dispose();
      await pumpEventQueue();
    },
  );

  test(
    'unavailable local recognition returns to manual without cloud fallback',
    () async {
      final calls = <String>[];
      messenger.setMockMethodCallHandler(const MethodChannel('focum/speech'), (
        call,
      ) async {
        calls.add(call.method);
        return call.method == 'start' ? false : null;
      });
      messenger.setMockMethodCallHandler(
        const MethodChannel('focum/speech_events'),
        (_) async => null,
      );
      addTearDown(() {
        messenger.setMockMethodCallHandler(
          const MethodChannel('focum/speech'),
          null,
        );
        messenger.setMockMethodCallHandler(
          const MethodChannel('focum/speech_events'),
          null,
        );
      });
      final service = VoiceInputService();
      final started = await service.startListening(
        onText: (_) => fail('No transcript expected'),
        onFinalText: (_) => fail('No transcript expected'),
        onListeningChanged: (_) => fail('Should not start listening'),
        onSoundLevelChanged: (_) => fail('No audio expected'),
        onError: (_) {},
      );
      expect(started, isFalse);
      expect(service.isListening, isFalse);
      expect(calls.where((method) => method == 'start'), hasLength(1));
      await service.stop();
    },
  );

  testWidgets(
    'offline policy has contact and data deletion needs confirmation',
    (tester) async {
      var deletions = 0;
      messenger.setMockMethodCallHandler(const MethodChannel('focum/native'), (
        call,
      ) async {
        if (call.method == 'clearLocalData') deletions++;
        return null;
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(
          const MethodChannel('focum/native'),
          null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PrivacyScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Iago Estevez Núñez'), findsOneWidget);
      expect(find.textContaining('iagoestevez1025@gmail.com'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(OutlinedButton),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      expect(deletions, 0);
      await tester.tap(find.text('Ahora no'));
      await tester.pumpAndSettle();
      expect(deletions, 0);
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Borrar datos locales'));
      await tester.pumpAndSettle();
      expect(deletions, 1);
    },
  );
}
