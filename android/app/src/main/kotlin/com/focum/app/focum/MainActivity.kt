package com.focum.app.focum

import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import android.view.View
import android.view.WindowManager
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

open class MainActivity : FlutterActivity() {
    private var onDeviceVoice: OnDeviceVoice? = null

    override fun onDestroy() {
        onDeviceVoice?.dispose()
        super.onDestroy()
    }
    companion object {
        const val ACTION_SHOW_UNLOCK_PROMPT = "com.focum.app.focum.action.SHOW_UNLOCK_PROMPT"
        private const val METHOD_CHANNEL = "focum/native"
        private const val EVENT_CHANNEL = "focum/unlock_events"
        private const val TAG = "Focum"
    }

    private val streamHandler =
        object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                PromptEventBridge.attach(events)
            }

            override fun onCancel(arguments: Any?) {
                PromptEventBridge.detach()
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "MainActivity.onCreate action=${intent?.action}")
        applyWindowModeForIntent(intent)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        Log.d(TAG, "MainActivity.onNewIntent action=${intent.action}")
        applyWindowModeForIntent(intent)
        handleIntent(intent)
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            applyWindowModeForIntent(intent)
        }
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "MainActivity.onResume action=${intent?.action}")
    }

    override fun onStop() {
        super.onStop()
        val promptIntent = intent?.action == ACTION_SHOW_UNLOCK_PROMPT
        Log.d(
            TAG,
            "MainActivity.onStop action=${intent?.action} finishing=$isFinishing changingConfig=$isChangingConfigurations",
        )
        if (promptIntent && !isFinishing && !isChangingConfigurations) {
            finishAndRemoveTask()
            @Suppress("DEPRECATION")
            overridePendingTransition(0, 0)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        onDeviceVoice = OnDeviceVoice(this, flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestPrivacyConsent" -> PrivacyConsent.request(this, call.argument<String>("kind").orEmpty(), result)
                    "clearLocalData" -> {
                        result.success(null)
                        UnlockMonitorService.stop(this)
                        (getSystemService(ACTIVITY_SERVICE) as android.app.ActivityManager).clearApplicationUserData()
                    }
                    "getInitialState" -> result.success(buildStatePayload())
                    "startMonitoring" -> {
                        UnlockMonitorService.start(this)
                        result.success(null)
                    }
                    "stopMonitoring" -> {
                        UnlockMonitorService.stop(this)
                        result.success(null)
                    }
                    "openOverlaySettings" -> {
                        openOverlaySettings()
                        result.success(null)
                    }
                    "openBatteryOptimizationSettings" -> {
                        openBatteryOptimizationSettings()
                        result.success(null)
                    }
                    "openUsageAccessSettings" -> {
                        AppUsageMonitor.openUsageAccessSettings(this)
                        result.success(null)
                    }
                    "activateCurrentIntention" -> {
                        val categoryId = call.argument<String>("categoryId")?.trim().orEmpty()
                        val reason = call.argument<String>("reason")?.trim().orEmpty()
                        if (categoryId.isNotEmpty() && reason.isNotEmpty()) {
                            IntentionAnchorOverlay.show(this, reason)
                            IntentionReminderScheduler.schedule(this, categoryId, reason)
                        }
                        result.success(null)
                    }
                    "dismissUnlockPrompt" -> {
                        FocumPrefs.setUnlockPromptPending(this, false)
                        result.success(null)
                        finishAndRemoveTask()
                        @Suppress("DEPRECATION")
                        overridePendingTransition(0, 0)
                    }
                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(streamHandler)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent?.action == ACTION_SHOW_UNLOCK_PROMPT) {
            Log.d(TAG, "MainActivity.handleIntent prompt")
            FocumPrefs.setUnlockPromptPending(this, true)
            PromptEventBridge.emitUnlockPrompt()
        }
    }

    private fun applyWindowModeForIntent(intent: Intent?) {
        val isPromptIntent = intent?.action == ACTION_SHOW_UNLOCK_PROMPT || this is UnlockPromptActivity
        val insetsController = WindowInsetsControllerCompat(window, window.decorView)

        if (isPromptIntent) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            window.setFlags(
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
            )
            window.statusBarColor = Color.TRANSPARENT
            window.navigationBarColor = Color.TRANSPARENT
            WindowCompat.setDecorFitsSystemWindows(window, false)
            window.decorView.systemUiVisibility = promptSystemUiFlags()
            insetsController.hide(WindowInsetsCompat.Type.systemBars())
            insetsController.systemBarsBehavior =
                WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
            return
        }

        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
        WindowCompat.setDecorFitsSystemWindows(window, true)
        insetsController.show(WindowInsetsCompat.Type.systemBars())
    }

    private fun promptSystemUiFlags(): Int =
        View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
            View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
            View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_FULLSCREEN or
            View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY

    private fun buildStatePayload(): Map<String, Any> =
        mapOf(
            "microphoneConsent" to PrivacyConsent.granted(this, "microphone"),
            "usageConsent" to PrivacyConsent.granted(this, "usage"),
            "overlayGranted" to hasOverlayPermission(),
            "usageAccessGranted" to AppUsageMonitor.hasUsageAccess(this),
            "batteryOptimizationIgnored" to isIgnoringBatteryOptimizations(),
            "monitoringEnabled" to FocumPrefs.isMonitoringEnabled(this),
            "pendingUnlockPrompt" to FocumPrefs.isUnlockPromptPending(this),
            "serviceRunning" to UnlockMonitorService.isRunning(this),
        )

    private fun hasOverlayPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
    }

    private fun isIgnoringBatteryOptimizations(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true
        }

        val powerManager = getSystemService(POWER_SERVICE) as PowerManager
        return powerManager.isIgnoringBatteryOptimizations(packageName)
    }

    private fun openOverlaySettings() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return
        }

        val intent =
            Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName"),
            ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun openBatteryOptimizationSettings() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return
        }

        val intent =
            Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }
}
