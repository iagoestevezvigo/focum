package com.focum.app.focum

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

class IntentionReminderReceiver : BroadcastReceiver() {
    companion object {
        private const val CHANNEL_ID = "focum_intention_reminders"

        fun showReminder(
            context: Context,
            reason: String,
            categoryId: String,
            requestCode: Int,
        ): Boolean {
            if (!FocumPrefs.isMonitoringEnabled(context)) {
                return false
            }

            if (reason.isEmpty() || categoryId.isEmpty()) {
                return false
            }

            if (!FocumPrefs.shouldDeliverReminder(context, System.currentTimeMillis())) {
                return false
            }

            vibrate(context)
            IntentionAnchorOverlay.show(context, reason)

            val foregroundApp = AppUsageMonitor.currentForegroundApp(context)
            val matchesIntention =
                foregroundApp == null || AppIntentMatcher.matches(context, categoryId, foregroundApp)
            if (foregroundApp != null && !matchesIntention) {
                FocusMismatchOverlay.show(
                    context = context,
                    intendedReason = reason,
                    appLabel = foregroundApp.label,
                )
            } else {
                FocusSessionReminderOverlay.show(
                    context = context,
                    message = reminderText(context, reason, foregroundApp, matchesIntention),
                )
            }

            if (!notificationsAllowed(context)) {
                return true
            }

            createChannel(context)

            val openIntent =
                Intent(context, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            val contentIntent =
                PendingIntent.getActivity(
                    context,
                    requestCode,
                    openIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )

            val reminderText = reminderText(context, reason, foregroundApp, matchesIntention)
            val notification =
                NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(R.drawable.ic_focum_notification)
                    .setContentTitle("Focum")
                    .setContentText(reminderText)
                    .setStyle(
                        NotificationCompat.BigTextStyle()
                            .bigText(reminderText),
                    )
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setAutoCancel(true)
                    .setContentIntent(contentIntent)
                    .build()

            NotificationManagerCompat.from(context).notify(requestCode, notification)
            return true
        }

        private fun vibrate(context: Context) {
            val vibrator =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    val manager =
                        context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                    manager.defaultVibrator
                } else {
                    @Suppress("DEPRECATION")
                    context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                }

            if (!vibrator.hasVibrator()) {
                return
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(
                    VibrationEffect.createWaveform(
                        longArrayOf(0L, 120L, 80L, 160L),
                        intArrayOf(0, 140, 0, 190),
                        -1,
                    ),
                )
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(longArrayOf(0L, 120L, 80L, 160L), -1)
            }
        }

        private fun reminderText(
            context: Context,
            reason: String,
            foregroundApp: ForegroundApp?,
            matchesIntention: Boolean,
        ): String {
            if (foregroundApp == null) {
                return context.getString(R.string.reminder_phone, reason)
            }

            return if (matchesIntention) {
                context.getString(R.string.reminder_app, foregroundApp.label, reason)
            } else {
                context.getString(R.string.reminder_intention, reason)
            }
        }

        private fun notificationsAllowed(context: Context): Boolean {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS,
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return false
            }

            return NotificationManagerCompat.from(context).areNotificationsEnabled()
        }

        private fun createChannel(context: Context) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                return
            }

            val manager = context.getSystemService(NotificationManager::class.java)
            val channel =
                NotificationChannel(
                    CHANNEL_ID,
                    context.getString(R.string.reminders_channel_name),
                    NotificationManager.IMPORTANCE_DEFAULT,
                ).apply {
                    description = context.getString(R.string.reminders_channel_description)
                }
            manager.createNotificationChannel(channel)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val activeIntention = FocumPrefs.activeIntention(context)
        val reason = IntentionReminderScheduler.extractReason(intent)
            .ifEmpty { activeIntention?.reason.orEmpty() }
        val categoryId = IntentionReminderScheduler.extractCategoryId(intent)
            .ifEmpty { activeIntention?.categoryId.orEmpty() }
        val delivered = showReminder(
            context = context,
            reason = reason,
            categoryId = categoryId,
            requestCode = IntentionReminderScheduler.extractRequestCode(intent),
        )
        if (delivered) {
            IntentionReminderScheduler.schedule(context, categoryId, reason)
        }
    }
}
