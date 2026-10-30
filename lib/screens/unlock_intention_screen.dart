import 'package:focum/l10n/l10n.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focum/design_system/focum_radius.dart';
import 'package:focum/design_system/focum_spacing.dart';
import 'package:focum/state/app_controller.dart';
import 'package:focum/widgets/focum_background.dart';
import 'package:focum/widgets/focum_intention_wheel.dart';
import 'package:focum/widgets/focum_mark.dart';
import 'package:focum/widgets/focum_voice_button.dart';

class UnlockIntentionScreen extends StatefulWidget {
  const UnlockIntentionScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<UnlockIntentionScreen> createState() => _UnlockIntentionScreenState();
}

class _UnlockIntentionScreenState extends State<UnlockIntentionScreen> {
  @override
  void initState() {
    super.initState();
    _enterImmersiveMode();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  Future<void> _enterImmersiveMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final spokenText = widget.controller.spokenText.trim();
    final activeVoice = widget.controller.isVoiceMode;
    final processing = widget.controller.isSubmittingIntent;
    final listening = widget.controller.isListening && !processing;

    final helperText = spokenText.isNotEmpty
        ? '"$spokenText"'
        : context.l10n.chooseBeforeEntering;
    final voiceHint = processing
        ? ''
        : listening
        ? context.l10n.listening
        : widget.controller.voiceIdleHint;
    final voiceAction = activeVoice
        ? widget.controller.switchToManualMode
        : widget.controller.switchToVoiceMode;

    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
              ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: FocumBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  FocumSpacing.lg,
                  FocumSpacing.lg,
                  FocumSpacing.lg,
                  FocumSpacing.xl,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final selectorWidth = math.min(constraints.maxWidth, 390.0);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FocumMark(
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: FocumSpacing.xs),
                            Text('Focum', style: theme.textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: FocumSpacing.xl),
                        Text(
                          context.l10n.intentionQuestion,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: FocumSpacing.sm),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            helperText,
                            key: ValueKey(helperText),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: FocumSpacing.lg),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FocumIntentionWheel(
                                categories: widget.controller.categories,
                                selectedCategoryId:
                                    widget.controller.selectedCategoryId,
                                onSelectionChanged:
                                    widget.controller.selectCategory,
                                onSelectionConfirmed:
                                    widget.controller.confirmCategorySelection,
                                maxSize: selectorWidth,
                              ),
                              const SizedBox(height: FocumSpacing.xxl),
                              ValueListenableBuilder<double>(
                                valueListenable:
                                    widget.controller.voiceSoundLevelListenable,
                                builder: (context, soundLevel, _) {
                                  return FocumVoiceButton(
                                    active: activeVoice,
                                    listening: listening,
                                    processing: processing,
                                    soundLevel: soundLevel,
                                    onPressed: voiceAction,
                                    hint: voiceHint,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        if (widget.controller.note != null) ...[
                          const SizedBox(height: FocumSpacing.lg),
                          Container(
                            padding: const EdgeInsets.all(FocumSpacing.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withValues(
                                alpha: 0.72,
                              ),
                              borderRadius: BorderRadius.circular(
                                FocumRadius.medium,
                              ),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Text(
                              widget.controller.note!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
