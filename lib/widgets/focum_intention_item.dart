import 'package:focum/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_radius.dart';
import 'package:focum/design_system/focum_spacing.dart';
import 'package:focum/models/intention_category.dart';

class FocumIntentionItem extends StatelessWidget {
  const FocumIntentionItem({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final IntentionCategory category;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return IgnorePointer(
      ignoring: !enabled,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 170),
          curve: Curves.easeOut,
          scale: selected ? 1.01 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 82,
            padding: const EdgeInsets.symmetric(
              horizontal: FocumSpacing.md,
              vertical: FocumSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primaryContainer.withValues(alpha: 0.74)
                  : scheme.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(FocumRadius.large),
              border: Border.all(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.24)
                    : scheme.outline.withValues(alpha: 0.68),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.surfaceContainerHighest.withValues(
                      alpha: selected ? 0.72 : 0.86,
                    ),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.42),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 22, height: 1),
                  ),
                ),
                const SizedBox(width: FocumSpacing.md),
                Expanded(
                  child: Text(
                    category.localizedLabel(context.l10n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: FocumSpacing.sm),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? scheme.primary : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? scheme.primary
                          : scheme.outline.withValues(alpha: 0.78),
                    ),
                  ),
                  child: selected
                      ? Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: scheme.onPrimary,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
