package com.focum.app.focum

import android.app.ActivityManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.content.res.Configuration
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class UnlockMonitorService : Service() {
    companion object {
        private const val ACTION_START = "com.focum.app.focum.action.START_MONITORING"
        private const val ACTION_STOP = "com.focum.app.focum.action.STOP_MONITORING"
        private const val NOTIFICATION_CHANNEL_ID = "focum_unlock_monitor"
        private const val NOTIFICATION_ID = 4107
        private const val TAG = "Focum"

        fun start(context: Context) {
            val intent = Intent(context, UnlockMonitorService::class.java).setAction(ACTION_START)
            ContextCompat.startForegroundService(context, intent)
        }

        fun stop(context: Context) {
            val intent = Intent(context, UnlockMonitorService::class.java).setAction(ACTION_STOP)
            context.startService(intent)
        }

        fun isRunning(context: Context): Boolean {
            val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            @Suppress("DEPRECATION")
            return manager.getRunningServices(Int.MAX_VALUE).any { serviceInfo ->
                serviceInfo.service.className == UnlockMonitorService::class.java.name
            }
        }
    }

    private val unlockReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                when (intent?.action) {
                    Intent.ACTION_USER_PRESENT -> onUserPresent()
                    Intent.ACTION_SCREEN_OFF -> onScreenOff()
                }
            }
        }

    private var receiverRegistered = false
    private val unlockPromptOverlay by lazy { UnlockPromptOverlay(this) }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "UnlockMonitorService.onCreate")
        createNotificationChannel()
        registerUnlockReceiver()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "UnlockMonitorService.onStartCommand action=${intent?.action}")
        if (intent?.action == ACTION_STOP) {
            FocumPrefs.setMonitoringEnabled(this, false)
            FocumPrefs.setUnlockPromptPending(this, false)
            IntentionReminderScheduler.cancel(this)
            DailyActivationReminderScheduler.cancel(this)
            IntentionAnchorOverlay.dismiss(this)
            FocusSessionReminderOverlay.dismiss(this)
            FocusMismatchOverlay.dismiss(this)
            unlockPromptOverlay.release()
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            return START_NOT_STICKY
        }

        FocumPrefs.setMonitoringEnabled(this, true)
        FocumPrefs.setUnlockPromptPending(this, false)
        registerUnlockReceiver()
        startAsForeground()
        unlockPromptOverlay.prepare()
        DailyActivationReminderScheduler.schedule(this)
        IntentionReminderScheduler.restore(this)
        return START_STICKY
    }

    override fun onDestroy() {
        Log.d(TAG, "UnlockMonitorService.onDestroy monitoring=${FocumPrefs.isMonitoringEnabled(this)}")
        unlockPromptOverlay.release()
        if (receiverRegistered) {
            unregisterReceiver(unlockReceiver)
            receiverRegistered = false
        }
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        createNotificationChannel()
        if (FocumPrefs.isMonitoringEnabled(this)) {
            startAsForeground()
            unlockPromptOverlay.refreshConfiguration()
        }
    }

    private fun startAsForeground() {
        val notification = buildNotification()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun buildNotification() =
        NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_focum_notification)
            .setContentTitle(getString(R.string.focum_active))
            .setContentText(getString(R.string.monitor_notification))
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .setContentIntent(buildContentIntent())
            .build()

    private fun buildContentIntent(): PendingIntent {
        val intent =
            Intent(this, MainActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)

        return PendingIntent.getActivity(
            this,
            2001,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val manager = getSystemService(NotificationManager::class.java)
        val channel =
            NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                getString(R.string.monitor_channel_name),
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = getString(R.string.monitor_channel_description)
            }

        manager.createNotificationChannel(channel)
    }

    private fun registerUnlockReceiver() {
        if (receiverRegistered) {
            return
        }

        val filter =
            IntentFilter().apply {
                addAction(Intent.ACTION_USER_PRESENT)
                addAction(Intent.ACTION_SCREEN_OFF)
            }
        ContextCompat.registerReceiver(
            this,
            unlockReceiver,
            filter,
            ContextCompat.RECEIVER_NOT_EXPORTED,
        )
        receiverRegistered = true
    }

    private fun onUserPresent() {
        if (!FocumPrefs.isMonitoringEnabled(this)) {
            Log.d(TAG, "Unlock skipped: monitoring disabled")
            return
        }

        if (!hasOverlayPermission()) {
            Log.d(TAG, "Unlock skipped: overlay permission missing")
            return
        }

        if (!FocumPrefs.shouldDispatchPrompt(this, System.currentTimeMillis())) {
            Log.d(TAG, "Unlock skipped: cooldown active")
            return
        }

        try {
            Log.d(TAG, "Unlock received: showing native overlay")
            FocumPrefs.setUnlockPromptPending(this, false)
            unlockPromptOverlay.show()
        } catch (error: RuntimeException) {
            Log.e(TAG, "Unlock overlay failed", error)
        }
    }

    private fun onScreenOff() {
        Log.d(TAG, "Screen turned off: dismissing native overlay")
        FocumPrefs.setUnlockPromptPending(this, false)
        IntentionReminderScheduler.cancel(this)
        IntentionAnchorOverlay.dismiss(this)
        FocusSessionReminderOverlay.dismiss(this)
        FocusMismatchOverlay.dismiss(this)
        unlockPromptOverlay.dismiss()
    }

    private fun hasOverlayPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
    }
}
