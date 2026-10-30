import 'package:focum/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_radius.dart';
import 'package:focum/design_system/focum_spacing.dart';
import 'package:focum/models/focum_permission.dart';
import 'package:focum/state/app_controller.dart';
import 'package:focum/widgets/focum_background.dart';
import 'package:focum/widgets/focum_button.dart';
import 'package:focum/widgets/focum_mark.dart';
import 'package:focum/widgets/focum_permission_row.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final pendingPermissions = controller.permissions.where(
      (permission) => !permission.granted,
    );
    final showActiveState =
        controller.monitoringEnabled && pendingPermissions.isEmpty;

    return Scaffold(
      body: FocumBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  FocumSpacing.lg,
                  FocumSpacing.lg,
                  FocumSpacing.lg,
                  FocumSpacing.xl,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: showActiveState
                      ? _ActiveState(controller: controller)
                      : _SetupState(
                          controller: controller,
                          allPermissions: controller.permissions,
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SetupState extends StatelessWidget {
  const _SetupState({required this.controller, required this.allPermissions});

  final AppController controller;
  final List<PermissionRequirement> allPermissions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(alignment: Alignment.center, child: _Header()),
        const SizedBox(height: FocumSpacing.lg),
        Text(
          context.l10n.setupTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: FocumSpacing.sm),
        Text(
          context.l10n.setupDescription,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: FocumSpacing.lg),
        _StatusCard(
          icon: controller.monitoringEnabled
              ? Icons.check_circle_outline_rounded
              : Icons.pause_circle_outline_rounded,
          title: controller.monitoringEnabled
              ? context.l10n.focumReady
              : context.l10n.focumInactive,
          description: controller.monitoringEnabled
              ? context.l10n.reviewPermissions
              : context.l10n.enablePermissions,
        ),
        const SizedBox(height: FocumSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(FocumRadius.large),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            children: [
              for (var index = 0; index < allPermissions.length; index++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FocumSpacing.md,
                  ),
                  child: FocumPermissionRow(
                    permission: allPermissions[index],
                    onPressed: () => controller.requestPermission(
                      allPermissions[index].type,
                    ),
                    showDivider: index != allPermissions.length - 1,
                  ),
                ),
            ],
          ),
        ),
        if (controller.note != null) ...[
          const SizedBox(height: FocumSpacing.lg),
          _InfoNote(text: controller.note!),
        ],
        const SizedBox(height: FocumSpacing.xl),
        FocumButton(
          label: controller.monitoringEnabled
              ? context.l10n.deactivateFocum
              : context.l10n.activateFocum,
          onPressed: controller.canActivate || controller.monitoringEnabled
              ? controller.toggleMonitoring
              : null,
        ),
        const SizedBox(height: FocumSpacing.md),
        Text(context.l10n.privacyNotice, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _ActiveState extends StatelessWidget {
  const _ActiveState({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(alignment: Alignment.center, child: _Header()),
        const SizedBox(height: FocumSpacing.lg),
        Text(
          context.l10n.focumActive,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: FocumSpacing.sm),
        Text(
          context.l10n.activeDescription,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: FocumSpacing.lg),
        _StatusCard(
          icon: Icons.brightness_1_rounded,
          title: context.l10n.allSet,
          description: context.l10n.permissionsGranted,
          emphasized: true,
        ),
        if (controller.note != null) ...[
          const SizedBox(height: FocumSpacing.lg),
          _InfoNote(text: controller.note!),
        ],
        const SizedBox(height: FocumSpacing.lg),
        FocumButton(
          label: context.l10n.deactivate,
          variant: FocumButtonVariant.secondary,
          onPressed: controller.toggleMonitoring,
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.description,
    this.emphasized = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FocumSpacing.lg),
      decoration: BoxDecoration(
        color: emphasized
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.72)
            : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(FocumRadius.large),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.75),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: FocumSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: FocumSpacing.xs),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FocumMark(size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: FocumSpacing.xs),
        Text('Focum', style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FocumSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(FocumRadius.medium),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }
}
