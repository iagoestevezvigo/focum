import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focum/l10n/l10n.dart';
import 'package:focum/models/focum_permission.dart';
import 'package:focum/models/intention_category.dart';
import 'package:focum/services/intention_classifier.dart';
import 'package:focum/services/voice_input_service.dart';
import 'package:focum/widgets/focum_intention_wheel.dart';
import 'package:focum/widgets/focum_permission_row.dart';

void main() {
  test(
    'resolves regional languages, preference lists and English fallback',
    () {
      for (final locale in AppLocalizations.supportedLocales) {
        expect(
          resolveAppLocalizations([locale]).localeName,
          locale.languageCode,
        );
      }
      expect(
        resolveAppLocalizations([const Locale('es', 'MX')]).localeName,
        'es',
      );
      expect(
        resolveAppLocalizations([const Locale('pt', 'BR')]).localeName,
        'pt',
      );
      expect(
        resolveAppLocalizations([const Locale('fr', 'CA')]).localeName,
        'fr',
      );
      expect(
        resolveAppLocalizations([
          const Locale('ja'),
          const Locale('it'),
        ]).localeName,
        'it',
      );
      expect(resolveAppLocalizations([const Locale('ja')]).localeName, 'en');
      expect(resolveAppLocalizations([]).localeName, 'en');
    },
  );

  test(
    'recognition matches installed regions and falls back to OS default',
    () {
      expect(
        resolveSpeechLocale([const Locale('pt', 'BR')], ['pt_PT', 'pt_BR']),
        'pt_BR',
      );
      expect(
        resolveSpeechLocale([const Locale('fr', 'CA')], ['fr_FR']),
        'fr_FR',
      );
      expect(
        resolveSpeechLocale(
          [const Locale('ja'), const Locale('de')],
          ['de-DE'],
        ),
        'de-DE',
      );
      expect(resolveSpeechLocale([const Locale('es')], ['en_US']), isNull);
      expect(resolveSpeechLocale([const Locale('es')], []), isNull);
    },
  );

  test(
    'classifies voice intentions in all six languages, including accents',
    () {
      final classifier = IntentionClassifier();
      const workSamples = [
        'Reply to a work email',
        'Responder correos del trabajo',
        'Je vais à une réunion de travail',
        'Ich arbeite an meinem Projekt',
        'Ho una riunione di lavoro',
        'Tenho uma reunião de trabalho',
        'Une re\u0301union',
      ];
      for (final sample in workSamples) {
        expect(
          classifier.classify(sample, IntentionCategory.defaults).id,
          'work',
          reason: sample,
        );
      }
      for (final sample in [
        'Je vais étudier mon cours',
        'Bücher lesen',
        'Vou ler um livro',
      ]) {
        expect(
          classifier.classify(sample, IntentionCategory.defaults).id,
          'learning',
          reason: sample,
        );
      }
      expect(
        classifier
            .classify('Consultar o médico', IntentionCategory.defaults)
            .id,
        'health',
      );
    },
  );

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      '${locale.languageCode}: categories and permissions fit a narrow screen',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final l10n = resolveAppLocalizations([locale]);
        await tester.pumpWidget(
          _localizedApp(
            locale: locale,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    FocumIntentionWheel(
                      categories: IntentionCategory.defaults,
                      selectedCategoryId: null,
                      onSelectionChanged: (_) {},
                      onSelectionConfirmed: (_) {},
                    ),
                    FocumPermissionRow(
                      permission: const PermissionRequirement(
                        type: FocumPermission.usageAccess,
                        granted: false,
                        requiredForActivation: false,
                      ),
                      onPressed: () {},
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        expect(find.text(l10n.categoryWork), findsOneWidget);
        expect(find.text(l10n.usagePermissionTitle), findsOneWidget);
        expect(find.text(l10n.openSettings), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('updates visible text when the device language changes', (
    tester,
  ) async {
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearLocalesTestValue);
    dispatcher.localesTestValue = [const Locale('es', 'MX')];
    await tester.pumpWidget(
      _localizedApp(
        child: Builder(builder: (context) => Text(context.l10n.setupTitle)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Configura Focum'), findsOneWidget);

    dispatcher.localesTestValue = [const Locale('de', 'DE')];
    await tester.pumpAndSettle();
    expect(find.text('Focum einrichten'), findsOneWidget);
    expect(find.text('Configura Focum'), findsNothing);

    dispatcher.localesTestValue = [const Locale('ja')];
    await tester.pumpAndSettle();
    expect(find.text('Set up Focum'), findsOneWidget);
  });
}

Widget _localizedApp({Locale? locale, required Widget child}) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: child,
);
