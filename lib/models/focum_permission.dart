import 'package:focum/l10n/l10n.dart';

enum FocumPermission {
  overlay,
  notifications,
  microphone,
  usageAccess,
  batteryOptimization,
}

class PermissionRequirement {
  const PermissionRequirement({
    required this.type,
    required this.granted,
    required this.requiredForActivation,
  });

  final FocumPermission type;
  final bool granted;
  final bool requiredForActivation;

  String title(AppLocalizations l10n) => switch (type) {
    FocumPermission.overlay => l10n.overlayPermissionTitle,
    FocumPermission.notifications => l10n.notificationPermissionTitle,
    FocumPermission.microphone => l10n.microphonePermissionTitle,
    FocumPermission.usageAccess => l10n.usagePermissionTitle,
    FocumPermission.batteryOptimization => l10n.batteryPermissionTitle,
  };

  String description(AppLocalizations l10n) => switch (type) {
    FocumPermission.overlay => l10n.overlayPermissionDescription,
    FocumPermission.notifications => l10n.notificationPermissionDescription,
    FocumPermission.microphone => l10n.microphonePermissionDescription,
    FocumPermission.usageAccess => l10n.usagePermissionDescription,
    FocumPermission.batteryOptimization => l10n.batteryPermissionDescription,
  };

  String actionLabel(AppLocalizations l10n) => switch (type) {
    FocumPermission.usageAccess ||
    FocumPermission.batteryOptimization => l10n.openSettings,
    _ => l10n.allowPermission,
  };

  String badgeLabel(AppLocalizations l10n) =>
      requiredForActivation ? l10n.requiredPermission : l10n.optionalPermission;
}
