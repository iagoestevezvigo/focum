import 'package:focum/l10n/l10n.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:focum/models/focum_permission.dart';
import 'package:focum/models/intention_category.dart';
import 'package:focum/models/intention_entry.dart';
import 'package:focum/services/intention_classifier.dart';
import 'package:focum/services/intention_repository.dart';
import 'package:focum/services/native_focum_service.dart';
import 'package:focum/services/permissions_service.dart';
import 'package:focum/services/voice_input_service.dart';

enum PromptSource { manual, unlockMonitor }

class AppController extends ChangeNotifier {
  AppController({
    required NativeFocumService nativeService,
    required PermissionsService permissionsService,
    required IntentionRepository repository,
    required VoiceInputService voiceInputService,
    required IntentionClassifier classifier,
  }) : _nativeService = nativeService,
       _permissionsService = permissionsService,
       _repository = repository,
       _voiceInputService = voiceInputService,
       _classifier = classifier;

  final NativeFocumService _nativeService;
  final PermissionsService _permissionsService;
  final IntentionRepository _repository;
  final VoiceInputService _voiceInputService;
  final IntentionClassifier _classifier;

  final List<IntentionCategory> categories = IntentionCategory.defaults;

  StreamSubscription<String>? _unlockSubscription;
  Timer? _speechActivityTimer;
  Timer? _voiceRestartTimer;
  List<PermissionRequirement> _permissions = const [];
  bool _isAppResumed = true;

  bool isLoading = true;
  bool promptVisible = false;
  bool monitoringEnabled = false;
  bool isListening = false;
  bool isVoiceMode = false;
  bool isSpeechDetected = false;
  double voiceSoundLevel = 0;
  final ValueNotifier<double> voiceSoundLevelListenable = ValueNotifier<double>(
    0.0,
  );

  PromptSource promptSource = PromptSource.manual;
  String? selectedCategoryId;
  String spokenText = '';
  bool _repeatVoiceHint = false;
  String Function(AppLocalizations)? _note;

  AppLocalizations get _l10n => resolveAppLocalizations(
    WidgetsBinding.instance.platformDispatcher.locales,
  );

  String get voiceIdleHint =>
      _repeatVoiceHint ? _l10n.voiceRetryHint : _l10n.voiceIdleHint;
  String? get note => _note?.call(_l10n);
  bool _isSubmittingIntent = false;

  List<PermissionRequirement> get permissions => _permissions;
  bool get isSubmittingIntent => _isSubmittingIntent;

  bool get canActivate {
    final overlay = permissionFor(FocumPermission.overlay);
    return overlay?.granted ?? false;
  }

  bool get canContinue {
    return selectedCategoryId != null || spokenText.trim().isNotEmpty;
  }

  IntentionCategory? get selectedCategory {
    if (selectedCategoryId == null) {
      return null;
    }

    for (final category in categories) {
      if (category.id == selectedCategoryId) {
        return category;
      }
    }

    return null;
  }

  PermissionRequirement? permissionFor(FocumPermission type) {
    for (final permission in _permissions) {
      if (permission.type == type) {
        return permission;
      }
    }
    return null;
  }

  Future<void> initialize() async {
    var nativeState = await _nativeService.fetchState();
    nativeState = await _restoreMonitoringIfNeeded(nativeState);
    monitoringEnabled = nativeState.monitoringEnabled;
    _permissions = await _permissionsService.loadRequirements(nativeState);

    _unlockSubscription = _nativeService.unlockEvents.listen((event) {
      if (event == NativeFocumService.unlockPromptEvent) {
        showUnlockPrompt(source: PromptSource.unlockMonitor);
      }
    });

    if (nativeState.pendingUnlockPrompt) {
      showUnlockPrompt(source: PromptSource.unlockMonitor, emitUpdate: false);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> handleLifecycleChanged(AppLifecycleState state) async {
    final resumed = state == AppLifecycleState.resumed;
    _isAppResumed = resumed;

    if (!resumed) {
      if (isListening) {
        await _voiceInputService.stop();
      }
      isListening = false;
      isSpeechDetected = false;
      _setVoiceSoundLevel(0);
      notifyListeners();
      return;
    }

    await refreshPermissions();
    if (promptVisible && isVoiceMode && !isListening) {
      unawaited(_startVoiceListening());
    }
  }

  Future<void> refreshPermissions() async {
    var nativeState = await _nativeService.fetchState();
    nativeState = await _restoreMonitoringIfNeeded(nativeState);
    monitoringEnabled = nativeState.monitoringEnabled;
    _permissions = await _permissionsService.loadRequirements(nativeState);
    if (nativeState.pendingUnlockPrompt && !promptVisible) {
      showUnlockPrompt(source: PromptSource.unlockMonitor, emitUpdate: false);
    }
    notifyListeners();
  }

  Future<void> requestPermission(FocumPermission permission) async {
    await _permissionsService.requestPermission(permission);
    if (permission == FocumPermission.microphone ||
        permission == FocumPermission.notifications) {
      await refreshPermissions();
    }
  }

  Future<void> toggleMonitoring() async {
    _note = null;
    if (monitoringEnabled) {
      await _nativeService.stopMonitoring();
      monitoringEnabled = false;
      _note = (l10n) => l10n.monitoringStopped;
      notifyListeners();
      await _refreshPermissionsAfterMonitoringChange(expectedEnabled: false);
      return;
    }

    if (!canActivate) {
      _note = (l10n) => l10n.overlayRequired;
      notifyListeners();
      return;
    }

    await _nativeService.startMonitoring();
    monitoringEnabled = true;
    _note = (l10n) => l10n.monitoringStarted;
    notifyListeners();
    await _refreshPermissionsAfterMonitoringChange(expectedEnabled: true);
  }

  Future<void> _refreshPermissionsAfterMonitoringChange({
    required bool expectedEnabled,
  }) async {
    NativeAppState nativeState = await _nativeService.fetchState();

    for (
      var attempt = 0;
      attempt < 6 && nativeState.monitoringEnabled != expectedEnabled;
      attempt++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      nativeState = await _nativeService.fetchState();
    }

    monitoringEnabled = nativeState.monitoringEnabled;
    _permissions = await _permissionsService.loadRequirements(nativeState);
    notifyListeners();
  }

  Future<NativeAppState> _restoreMonitoringIfNeeded(
    NativeAppState state,
  ) async {
    if (!state.monitoringEnabled || state.serviceRunning) {
      return state;
    }

    await _nativeService.startMonitoring();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _nativeService.fetchState();
  }

  void selectCategory(String categoryId) {
    final shouldStopVoice = isVoiceMode || isListening;
    isVoiceMode = false;
    isListening = false;
    isSpeechDetected = false;
    _setVoiceSoundLevel(0);
    selectedCategoryId = categoryId;
    _note = null;
    if (shouldStopVoice) {
      unawaited(_voiceInputService.stop());
    }
    notifyListeners();
  }

  Future<void> confirmCategorySelection(String categoryId) async {
    if (_isSubmittingIntent) {
      return;
    }

    selectCategory(categoryId);
    await submitCurrentIntent();
  }

  Future<void> toggleListening() async {
    if (isVoiceMode) {
      await switchToManualMode();
      return;
    }

    await switchToVoiceMode();
  }

  Future<void> switchToManualMode() async {
    _note = null;
    _voiceRestartTimer?.cancel();
    _speechActivityTimer?.cancel();
    isVoiceMode = false;
    isListening = false;
    isSpeechDetected = false;
    _setVoiceSoundLevel(0);
    spokenText = '';
    _repeatVoiceHint = false;
    selectedCategoryId = null;
    notifyListeners();
    await _voiceInputService.stop();
  }

  Future<void> switchToVoiceMode() async {
    _note = null;
    isListening = false;
    isSpeechDetected = false;
    _setVoiceSoundLevel(0);
    isVoiceMode = true;
    selectedCategoryId = null;
    spokenText = '';
    _repeatVoiceHint = false;
    notifyListeners();

    await _startVoiceListening();
  }

  Future<void> _startVoiceListening() async {
    _voiceRestartTimer?.cancel();
    _speechActivityTimer?.cancel();

    if (!promptVisible || !isVoiceMode || _isSubmittingIntent) {
      return;
    }

    if (!_isAppResumed) {
      return;
    }

    final microphoneGranted = await _permissionsService
        .ensureMicrophonePermission();
    if (!microphoneGranted) {
      isVoiceMode = false;
      _note = (l10n) => l10n.microphoneRequired;
      notifyListeners();
      await refreshPermissions();
      return;
    }

    final started = await _voiceInputService.startListening(
      onText: _handleVoiceText,
      onFinalText: _handleFinalVoiceText,
      onListeningChanged: (listening) {
        isListening = listening;
        if (!listening) {
          isSpeechDetected = false;
          _setVoiceSoundLevel(0);
          final shouldRetryVoice =
              spokenText.trim().isEmpty &&
              promptVisible &&
              isVoiceMode &&
              !_isSubmittingIntent;
          if (shouldRetryVoice) {
            _repeatVoiceHint = true;
            _scheduleVoiceRestart();
          }
        }
        notifyListeners();
      },
      onSoundLevelChanged: (level) {
        if (!isListening || !isVoiceMode) {
          return;
        }
        _setVoiceSoundLevel(_normalizeSoundLevel(level));
        if (level > 2) {
          _pulseSpeechActivity();
        }
      },
      onError: (message) {
        _voiceRestartTimer?.cancel();
        isVoiceMode = false;
        _note = (l10n) => l10n.speechUnavailable;
        _repeatVoiceHint = true;
        isListening = false;
        isSpeechDetected = false;
        _setVoiceSoundLevel(0);
        notifyListeners();
      },
    );

    if (!started) {
      _note = (l10n) => l10n.speechUnavailable;
      isVoiceMode = false;
      isListening = false;
      isSpeechDetected = false;
      _setVoiceSoundLevel(0);
      _repeatVoiceHint = false;
      notifyListeners();
    }
  }

  Future<void> submitCurrentIntent() async {
    if (_isSubmittingIntent) {
      return;
    }

    _isSubmittingIntent = true;
    notifyListeners();
    final category = _resolveCategory();
    if (category == null) {
      _note = (l10n) => l10n.chooseCategoryOrSpeak;
      _isSubmittingIntent = false;
      notifyListeners();
      return;
    }

    try {
      final trimmedText = _cleanDescription(spokenText);
      final entry = IntentionEntry(
        timestamp: DateTime.now(),
        category: category.id,
        description: trimmedText,
        inputMethod: trimmedText == null
            ? IntentionInputMethod.wheel
            : IntentionInputMethod.voice,
      );

      await _repository.saveEntry(entry);
      if (monitoringEnabled) {
        await _nativeService.activateCurrentIntention(
          categoryId: category.id,
          reason: trimmedText ?? category.localizedLabel(_l10n),
        );
      }
      await _voiceInputService.stop();

      if (promptSource == PromptSource.unlockMonitor) {
        await _nativeService.dismissUnlockPrompt();
        promptVisible = false;
        _resetPromptState();
        notifyListeners();
        return;
      }

      promptVisible = false;
      _resetPromptState();
      _note = (l10n) => l10n.intentionSaved;
      notifyListeners();
    } finally {
      _isSubmittingIntent = false;
      if (promptVisible) {
        notifyListeners();
      }
    }
  }

  void showUnlockPrompt({
    required PromptSource source,
    bool emitUpdate = true,
  }) {
    promptVisible = true;
    promptSource = source;
    // Opening the unlock prompt must not open the microphone automatically.
    _resetPromptState();
    if (emitUpdate) {
      notifyListeners();
    }
  }

  IntentionCategory? _resolveCategory() {
    if (selectedCategory != null) {
      return selectedCategory;
    }

    final trimmed = spokenText.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    return _classifier.classify(trimmed, categories);
  }

  void _handleVoiceText(String text) {
    spokenText = text;
    if (text.trim().isEmpty) {
      isSpeechDetected = false;
      notifyListeners();
      return;
    }

    _pulseSpeechActivity();
    _repeatVoiceHint = false;
    selectedCategoryId = _classifier.classify(text, categories).id;
    notifyListeners();
  }

  Future<void> _handleFinalVoiceText(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      isSpeechDetected = false;
      _repeatVoiceHint = true;
      _scheduleVoiceRestart();
      notifyListeners();
      return;
    }

    _handleVoiceText(trimmed);
    await Future<void>.delayed(const Duration(milliseconds: 180));
    await submitCurrentIntent();
  }

  void _resetPromptState({bool voiceMode = false}) {
    _voiceRestartTimer?.cancel();
    _speechActivityTimer?.cancel();
    selectedCategoryId = null;
    spokenText = '';
    _repeatVoiceHint = false;
    isListening = false;
    isVoiceMode = voiceMode;
    isSpeechDetected = false;
    _setVoiceSoundLevel(0);
    _note = null;
  }

  void _pulseSpeechActivity() {
    isSpeechDetected = true;
    _speechActivityTimer?.cancel();
    _speechActivityTimer = Timer(const Duration(milliseconds: 480), () {
      if (!isListening) {
        return;
      }
      isSpeechDetected = false;
      _setVoiceSoundLevel(0);
      notifyListeners();
    });
  }

  void _setVoiceSoundLevel(double value) {
    voiceSoundLevel = value.clamp(0.0, 1.0).toDouble();
    voiceSoundLevelListenable.value = voiceSoundLevel;
  }

  double _normalizeSoundLevel(double level) {
    return ((level - 2) / 8).clamp(0.0, 1.0).toDouble();
  }

  void _scheduleVoiceRestart() {
    _voiceRestartTimer?.cancel();
    _voiceRestartTimer = Timer(const Duration(milliseconds: 360), () {
      if (!promptVisible ||
          !isVoiceMode ||
          isListening ||
          _isSubmittingIntent ||
          spokenText.trim().isNotEmpty) {
        return;
      }
      unawaited(_startVoiceListening());
    });
  }

  String? _cleanDescription(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final first = trimmed.substring(0, 1).toUpperCase();
    if (trimmed.length == 1) {
      return first;
    }
    return '$first${trimmed.substring(1)}';
  }

  @override
  void dispose() {
    _unlockSubscription?.cancel();
    _speechActivityTimer?.cancel();
    _voiceRestartTimer?.cancel();
    voiceSoundLevelListenable.dispose();
    _voiceInputService.stop();
    super.dispose();
  }
}
