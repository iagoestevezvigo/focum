import 'package:flutter/material.dart';
import 'package:focum/l10n/l10n.dart';
import 'package:focum/screens/setup_screen.dart';
import 'package:focum/screens/unlock_intention_screen.dart';
import 'package:focum/services/intention_classifier.dart';
import 'package:focum/services/intention_repository.dart';
import 'package:focum/services/native_focum_service.dart';
import 'package:focum/services/permissions_service.dart';
import 'package:focum/services/voice_input_service.dart';
import 'package:focum/state/app_controller.dart';
import 'package:focum/theme/app_theme.dart';
import 'package:focum/widgets/focum_background.dart';
import 'package:focum/widgets/focum_mark.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final nativeService = NativeFocumService();
  final permissionsService = PermissionsService(nativeService);
  final controller = AppController(
    nativeService: nativeService,
    permissionsService: permissionsService,
    repository: IntentionRepository(),
    voiceInputService: VoiceInputService(),
    classifier: IntentionClassifier(),
  );

  await controller.initialize();

  runApp(FocumApp(controller: controller));
}

class FocumApp extends StatefulWidget {
  const FocumApp({super.key, required this.controller});

  final AppController controller;

  @override
  State<FocumApp> createState() => _FocumAppState();
}

class _FocumAppState extends State<FocumApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.handleLifecycleChanged(
      WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.controller.handleLifecycleChanged(state);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Focum',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.build(),
          darkTheme: AppTheme.buildDark(),
          themeMode: ThemeMode.system,
          home: widget.controller.isLoading
              ? const _LoadingScreen()
              : widget.controller.promptVisible
              ? UnlockIntentionScreen(controller: widget.controller)
              : SetupScreen(controller: widget.controller),
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FocumBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FocumMark(size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 18),
              Text('Focum', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                context.l10n.preparingPause,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
