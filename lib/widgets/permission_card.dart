import 'package:focum/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:focum/models/focum_permission.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    super.key,
    required this.permission,
    required this.onPressed,
  });

  final PermissionRequirement permission;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isGranted = permission.granted;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isGranted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isGranted ? colorScheme.primary : colorScheme.outline,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    permission.title(context.l10n),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _PermissionBadge(
                  label: permission.badgeLabel(context.l10n),
                  emphasized: permission.requiredForActivation,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              permission.description(context.l10n),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonal(
                onPressed: isGranted ? null : onPressed,
                child: Text(
                  isGranted
                      ? context.l10n.grantedPermission
                      : permission.actionLabel(context.l10n),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionBadge extends StatelessWidget {
  const _PermissionBadge({required this.label, required this.emphasized});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = emphasized
        ? colorScheme.primary.withValues(alpha: 0.12)
        : colorScheme.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: emphasized ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
