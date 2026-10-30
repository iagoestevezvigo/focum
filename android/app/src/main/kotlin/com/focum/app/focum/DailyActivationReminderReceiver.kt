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
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

class DailyActivationReminderReceiver : BroadcastReceiver() {
    companion object {
        private const val CHANNEL_ID = "focum_activation_reminders"
        private const val NOTIFICATION_ID = 4109
        private const val REQUEST_CODE_OPEN_APP = 4110

        fun showIfNeeded(context: Context): Boolean {
            val appContext = context.applicationContext
            if (!FocumPrefs.isMonitoringEnabled(appContext)) {
                return false
            }

            if (UnlockMonitorService.isRunning(appContext)) {
                return false
            }

            if (!notificationsAllowed(appContext)) {
                return false
            }

            createChannel(appContext)

            val openIntent =
                Intent(appContext, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            val contentIntent =
                PendingIntent.getActivity(
                    appContext,
                    REQUEST_CODE_OPEN_APP,
                    openIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
            val reminderText =
                appContext.getString(R.string.activation_reminder)
            val notification =
                NotificationCompat.Builder(appContext, CHANNEL_ID)
                    .setSmallIcon(R.drawable.ic_focum_notification)
                    .setContentTitle(appContext.getString(R.string.reopen_focum))
                    .setContentText(reminderText)
                    .setStyle(NotificationCompat.BigTextStyle().bigText(reminderText))
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setAutoCancel(true)
                    .setContentIntent(contentIntent)
                    .build()

            NotificationManagerCompat.from(appContext).notify(NOTIFICATION_ID, notification)
            return true
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
                    context.getString(R.string.status_channel_name),
                    NotificationManager.IMPORTANCE_DEFAULT,
                ).apply {
                    description = context.getString(R.string.status_channel_description)
                }
            manager.createNotificationChannel(channel)
        }
    }

    override fun onReceive(context: Context, intent: Intent?) {
        if (FocumPrefs.isMonitoringEnabled(context)) {
            DailyActivationReminderScheduler.scheduleNext(context)
        }
        showIfNeeded(context)
    }
}
