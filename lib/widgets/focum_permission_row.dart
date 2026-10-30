import 'package:focum/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_radius.dart';
import 'package:focum/design_system/focum_spacing.dart';
import 'package:focum/models/focum_permission.dart';

class FocumPermissionRow extends StatelessWidget {
  const FocumPermissionRow({
    super.key,
    required this.permission,
    required this.onPressed,
    required this.showDivider,
  });

  final PermissionRequirement permission;
  final VoidCallback onPressed;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isGranted = permission.granted;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: FocumSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: permission.granted
                      ? scheme.primaryContainer
                      : scheme.surfaceContainerHighest.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(FocumRadius.small),
                ),
                child: Icon(
                  _iconFor(permission.type),
                  size: 20,
                  color: permission.granted
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: FocumSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      permission.title(context.l10n),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: FocumSpacing.xs),
                    _PermissionBadge(
                      label: permission.requiredForActivation
                          ? context.l10n.requiredPermission
                          : context.l10n.optionalPermission,
                      emphasized: permission.requiredForActivation,
                    ),
                    const SizedBox(height: FocumSpacing.sm),
                    Text(
                      permission.description(context.l10n),
                      style: theme.textTheme.bodySmall,
                    ),
                    if (!isGranted) ...[
                      const SizedBox(height: FocumSpacing.md),
                      _PermissionAction(
                        label: permission.actionLabel(context.l10n),
                        onPressed: onPressed,
                      ),
                    ],
                  ],
                ),
              ),
              if (isGranted) ...[
                const SizedBox(width: FocumSpacing.md),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: scheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showDivider) Divider(color: theme.dividerColor),
      ],
    );
  }

  IconData _iconFor(FocumPermission permissionType) {
    switch (permissionType) {
      case FocumPermission.overlay:
        return Icons.lock_open_rounded;
      case FocumPermission.notifications:
        return Icons.notifications_none_rounded;
      case FocumPermission.microphone:
        return Icons.mic_none_rounded;
      case FocumPermission.usageAccess:
        return Icons.visibility_outlined;
      case FocumPermission.batteryOptimization:
        return Icons.battery_charging_full_rounded;
    }
  }
}

class _PermissionBadge extends StatelessWidget {
  const _PermissionBadge({required this.label, required this.emphasized});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: emphasized
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(FocumRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: emphasized ? scheme.primary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PermissionAction extends StatelessWidget {
  const _PermissionAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FocumRadius.pill),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(FocumRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FocumSpacing.md,
            vertical: 10,
          ),
          child: Text(label, style: theme.textTheme.labelLarge),
        ),
      ),
    );
  }
}
