import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_colors.dart';
import 'package:focum/design_system/focum_spacing.dart';

class FocumVoiceButton extends StatefulWidget {
  const FocumVoiceButton({
    super.key,
    required this.active,
    required this.listening,
    required this.processing,
    required this.soundLevel,
    required this.onPressed,
    required this.hint,
  });

  final bool active;
  final bool listening;
  final bool processing;
  final double soundLevel;
  final VoidCallback onPressed;
  final String hint;

  @override
  State<FocumVoiceButton> createState() => _FocumVoiceButtonState();
}

class _FocumVoiceButtonState extends State<FocumVoiceButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final level =
        (widget.listening && !widget.processing
                ? widget.soundLevel.clamp(0.0, 1.0)
                : 0.0)
            .toDouble();
    final engaged =
        widget.active || widget.listening || widget.processing || _pressed;
    final pressGrowth = engaged ? 1.0 : 0.0;
    final ringSize = 87.75 + (pressGrowth * 26.325) + (level * 75.4);
    final dotSize = 29.25 + (pressGrowth * 11.7);
    final ringAlpha = 0.4 + (pressGrowth * 0.12) + (level * 0.2);
    final ringWidth = 4.1 + (pressGrowth * 0.585) + (level * 2.34);
    final GestureTapDownCallback? onTapDown = widget.processing
        ? null
        : (TapDownDetails _) => setState(() => _pressed = true);
    final GestureTapCancelCallback? onTapCancel = widget.processing
        ? null
        : () => setState(() => _pressed = false);
    final GestureTapUpCallback? onTapUp = widget.processing
        ? null
        : (TapUpDetails _) => setState(() => _pressed = false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.processing ? null : widget.onPressed,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onTapUp: onTapUp,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 218,
            height: 218,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  width: ringSize,
                  height: ringSize,
                  decoration: widget.processing
                      ? null
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scheme.primary.withValues(alpha: ringAlpha),
                            width: ringWidth,
                          ),
                        ),
                  child: widget.processing
                      ? CircularProgressIndicator(
                          strokeWidth: ringWidth,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            scheme.primary.withValues(alpha: 0.72),
                          ),
                        )
                      : null,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FocumColors.signalRed,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.hint.isNotEmpty) ...[
          const SizedBox(height: FocumSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: Text(
                widget.hint,
                key: ValueKey(widget.hint),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
