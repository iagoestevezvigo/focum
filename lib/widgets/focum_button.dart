import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_radius.dart';
import 'package:focum/design_system/focum_spacing.dart';

enum FocumButtonVariant { primary, secondary }

class FocumButton extends StatelessWidget {
  const FocumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FocumButtonVariant.primary,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final FocumButtonVariant variant;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onPressed != null;
    final primary = variant == FocumButtonVariant.primary;

    final backgroundColor = primary
        ? scheme.primary
        : theme.cardTheme.color ?? theme.colorScheme.surface;
    final foregroundColor = primary ? scheme.onPrimary : scheme.onSurface;
    final borderColor = primary
        ? Colors.transparent
        : theme.dividerColor.withValues(alpha: enabled ? 1 : 0.6);

    final button = AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FocumRadius.medium),
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(FocumRadius.medium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FocumSpacing.lg,
              vertical: FocumSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: foregroundColor),
                  const SizedBox(width: FocumSpacing.sm),
                ],
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!expand) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
