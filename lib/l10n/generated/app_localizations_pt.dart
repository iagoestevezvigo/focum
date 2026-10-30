// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get preparingPause => 'A preparar a tua pausa.';

  @override
  String get setupTitle => 'Configura o Focum';

  @override
  String get setupDescription =>
      'Só precisamos de algumas permissões para te ajudar a usar o telemóvel com intenção.';

  @override
  String get focumReady => 'O Focum está pronto';

  @override
  String get focumInactive => 'O Focum ainda não está ativo';

  @override
  String get reviewPermissions =>
      'Revê as permissões ou ativa-o quando quiseres.';

  @override
  String get enablePermissions =>
      'Concede as permissões necessárias e depois ativa o Focum.';

  @override
  String get activateFocum => 'Ativar Focum';

  @override
  String get deactivateFocum => 'Desativar Focum';

  @override
  String get privacyNotice =>
      'Privacidade: guardamos a data, hora, categoria e texto final. O áudio é processado pelo serviço de reconhecimento de voz do dispositivo.';

  @override
  String get focumActive => 'Focum ativo';

  @override
  String get activeDescription =>
      'O Focum vai ajudar-te sempre que desbloqueares o telemóvel.';

  @override
  String get allSet => 'Tudo pronto';

  @override
  String get permissionsGranted =>
      'As permissões principais já foram concedidas.';

  @override
  String get deactivate => 'Desativar';

  @override
  String get chooseBeforeEntering =>
      'Escolhe o motivo principal antes de continuar.';

  @override
  String get listening => 'Estou a ouvir';

  @override
  String get intentionQuestion => 'Para que vais usar o telemóvel agora?';

  @override
  String get voiceIdleHint => 'Toca e diz o teu motivo';

  @override
  String get voiceRetryHint => 'Repete, não percebi';

  @override
  String get monitoringStopped => 'Focum desativado.';

  @override
  String get overlayRequired =>
      'Permite que o Focum apareça ao desbloquear antes de o ativares.';

  @override
  String get monitoringStarted =>
      'O Focum está ativo. Vai acompanhar-te sempre que desbloqueares.';

  @override
  String get microphoneRequired =>
      'Ativa o microfone para usar a entrada por voz.';

  @override
  String get speechUnavailable =>
      'O reconhecimento de voz não está disponível neste dispositivo.';

  @override
  String get chooseCategoryOrSpeak =>
      'Escolhe uma categoria ou diz o teu motivo.';

  @override
  String get intentionSaved => 'Intenção registada.';

  @override
  String get requiredPermission => 'Necessário';

  @override
  String get optionalPermission => 'Opcional';

  @override
  String get allowPermission => 'Permitir';

  @override
  String get openSettings => 'Abrir definições';

  @override
  String get grantedPermission => 'Concedido';

  @override
  String get overlayPermissionTitle => 'Mostrar ao desbloquear';

  @override
  String get overlayPermissionDescription =>
      'Necessário para que o Focum apareça assim que desbloqueias.';

  @override
  String get notificationPermissionTitle => 'Serviço visível';

  @override
  String get notificationPermissionDescription =>
      'Mostra que o Focum está ativo.';

  @override
  String get microphonePermissionTitle => 'Usar a voz';

  @override
  String get microphonePermissionDescription =>
      'Diz a tua intenção numa frase curta.';

  @override
  String get usagePermissionTitle => 'Ver a app em uso';

  @override
  String get usagePermissionDescription =>
      'Permite avisar-te se a app aberta não corresponde à tua intenção.';

  @override
  String get batteryPermissionTitle => 'Atividade em segundo plano';

  @override
  String get batteryPermissionDescription =>
      'Opcional. Ajuda a evitar que o Android pare o Focum automaticamente.';

  @override
  String get manualMode => 'Manual';

  @override
  String get voiceMode => 'Voz';

  @override
  String get chooseMainReason => 'Escolhe o motivo principal.';

  @override
  String get tapAnIcon => 'Toca num ícone';

  @override
  String get orUseMicrophone => 'ou usa o microfone';

  @override
  String get savedInstantly => 'Guardado de imediato';

  @override
  String get categoryLearning => 'Aprender';

  @override
  String get categoryWork => 'Trabalho';

  @override
  String get categoryPersonalGrowth => 'Desenvolvimento pessoal';

  @override
  String get categorySocial => 'Socializar';

  @override
  String get categoryHealth => 'Saúde';

  @override
  String get categoryTravel => 'Viagens';

  @override
  String get categoryPersonal => 'Pessoal';

  @override
  String get categoryOther => 'Outros';

  @override
  String get focusMismatchTitle => 'Mantém o foco.';

  @override
  String focusMismatchMessage(String reason, String app) {
    return 'Disseste que ias usar o telemóvel para $reason, mas agora estás em $app.';
  }

  @override
  String get returnToIntention => 'Voltar à minha intenção';

  @override
  String get fiveMinutesTitle => 'Já passaram 5 minutos.';

  @override
  String get keepGoing => 'Continuo com isso';

  @override
  String reminderPhone(String reason) {
    return 'Estás a usar o telemóvel há 5 minutos para $reason.';
  }

  @override
  String reminderApp(String app, String reason) {
    return 'Estás em $app há 5 minutos para $reason.';
  }

  @override
  String reminderIntention(String reason) {
    return 'Estás a usar o telemóvel há 5 minutos. Disseste que era para $reason.';
  }

  @override
  String get reopenFocum => 'Volta a abrir o Focum';

  @override
  String get activationReminder =>
      'O Android pode ter pausado o Focum. Abre a app e volta a ativar o Focum.';

  @override
  String get statusChannelName => 'Estado do Focum';

  @override
  String get statusChannelDescription =>
      'Lembretes diários para voltar a abrir o Focum se o Android o parar.';

  @override
  String get remindersChannelName => 'Lembretes do Focum';

  @override
  String get remindersChannelDescription =>
      'Lembretes das intenções guardadas ao desbloquear.';

  @override
  String get monitorChannelName => 'Monitor do Focum';

  @override
  String get monitorChannelDescription =>
      'Mantém ativo o monitor de desbloqueio do Focum.';

  @override
  String get monitorNotification =>
      'O Focum vai perguntar a tua intenção ao desbloquear.';

  @override
  String get sayBeforeEntering => 'Diz numa frase curta antes de continuar.';
}
