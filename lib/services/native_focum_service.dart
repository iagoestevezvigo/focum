import 'package:flutter/services.dart';

class NativeAppState {
  const NativeAppState({
    this.microphoneConsent = false,
    this.usageConsent = false,
    required this.overlayGranted,
    required this.usageAccessGranted,
    required this.batteryOptimizationIgnored,
    required this.monitoringEnabled,
    required this.pendingUnlockPrompt,
    required this.serviceRunning,
  });

  final bool overlayGranted;
  final bool microphoneConsent;
  final bool usageConsent;
  final bool usageAccessGranted;
  final bool batteryOptimizationIgnored;
  final bool monitoringEnabled;
  final bool pendingUnlockPrompt;
  final bool serviceRunning;

  factory NativeAppState.fromMap(Map<dynamic, dynamic> data) {
    return NativeAppState(
      microphoneConsent: data['microphoneConsent'] as bool? ?? false,
      usageConsent: data['usageConsent'] as bool? ?? false,
      overlayGranted: data['overlayGranted'] as bool? ?? false,
      usageAccessGranted: data['usageAccessGranted'] as bool? ?? false,
      batteryOptimizationIgnored:
          data['batteryOptimizationIgnored'] as bool? ?? false,
      monitoringEnabled: data['monitoringEnabled'] as bool? ?? false,
      pendingUnlockPrompt: data['pendingUnlockPrompt'] as bool? ?? false,
      serviceRunning: data['serviceRunning'] as bool? ?? false,
    );
  }
}

class NativeFocumService {
  static const String unlockPromptEvent = 'unlock_prompt';
  static const MethodChannel _methodChannel = MethodChannel('focum/native');
  static const EventChannel _eventChannel = EventChannel('focum/unlock_events');

  Stream<String> get unlockEvents {
    return _eventChannel.receiveBroadcastStream().map(
      (dynamic event) => event?.toString() ?? '',
    );
  }

  Future<NativeAppState> fetchState() async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>(
          'getInitialState',
        ) ??
        <String, dynamic>{};
    return NativeAppState.fromMap(data);
  }

  Future<void> startMonitoring() {
    return _methodChannel.invokeMethod<void>('startMonitoring');
  }

  Future<void> stopMonitoring() {
    return _methodChannel.invokeMethod<void>('stopMonitoring');
  }

  Future<void> openOverlaySettings() {
    return _methodChannel.invokeMethod<void>('openOverlaySettings');
  }

  Future<void> openBatteryOptimizationSettings() {
    return _methodChannel.invokeMethod<void>('openBatteryOptimizationSettings');
  }

  Future<void> openUsageAccessSettings() {
    return _methodChannel.invokeMethod<void>('openUsageAccessSettings');
  }

  Future<bool> requestPrivacyConsent(String kind) async =>
      await _methodChannel.invokeMethod<bool>('requestPrivacyConsent', {
        'kind': kind,
      }) ??
      false;

  Future<void> clearLocalData() =>
      _methodChannel.invokeMethod<void>('clearLocalData');

  Future<void> activateCurrentIntention({
    required String categoryId,
    required String reason,
  }) {
    return _methodChannel.invokeMethod<void>('activateCurrentIntention', {
      'categoryId': categoryId,
      'reason': reason,
    });
  }

  Future<void> dismissUnlockPrompt() {
    return _methodChannel.invokeMethod<void>('dismissUnlockPrompt');
  }
}
