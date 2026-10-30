import 'package:focum/models/focum_permission.dart';
import 'package:focum/services/native_focum_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  const PermissionsService(this._nativeService);

  final NativeFocumService _nativeService;

  Future<List<PermissionRequirement>> loadRequirements(
    NativeAppState nativeState,
  ) async {
    final notificationStatus = await Permission.notification.status;
    final microphoneStatus = await Permission.microphone.status;

    return [
      PermissionRequirement(
        type: FocumPermission.overlay,
        granted: nativeState.overlayGranted,
        requiredForActivation: true,
      ),
      PermissionRequirement(
        type: FocumPermission.notifications,
        granted: notificationStatus.isGranted,
        requiredForActivation: false,
      ),
      PermissionRequirement(
        type: FocumPermission.microphone,
        granted: microphoneStatus.isGranted && nativeState.microphoneConsent,
        requiredForActivation: false,
      ),
      PermissionRequirement(
        type: FocumPermission.usageAccess,
        granted: nativeState.usageAccessGranted && nativeState.usageConsent,
        requiredForActivation: false,
      ),
      PermissionRequirement(
        type: FocumPermission.batteryOptimization,
        granted: nativeState.batteryOptimizationIgnored,
        requiredForActivation: false,
      ),
    ];
  }

  Future<void> requestPermission(FocumPermission permission) async {
    switch (permission) {
      case FocumPermission.overlay:
        await _nativeService.openOverlaySettings();
        return;
      case FocumPermission.notifications:
        await _requestRuntimePermission(Permission.notification);
        return;
      case FocumPermission.microphone:
        if (!await _nativeService.requestPrivacyConsent('microphone')) return;
        await _requestRuntimePermission(Permission.microphone);
        return;
      case FocumPermission.usageAccess:
        if (!await _nativeService.requestPrivacyConsent('usage')) return;
        await _nativeService.openUsageAccessSettings();
        return;
      case FocumPermission.batteryOptimization:
        await _nativeService.openBatteryOptimizationSettings();
        return;
    }
  }

  Future<bool> ensureMicrophonePermission() async {
    if (!await _nativeService.requestPrivacyConsent('microphone')) return false;
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    }

    final requested = await Permission.microphone.request();
    if (requested.isPermanentlyDenied) {
      await openAppSettings();
    }

    return requested.isGranted;
  }

  Future<void> _requestRuntimePermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return;
    }

    final requested = await permission.request();
    if (requested.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
