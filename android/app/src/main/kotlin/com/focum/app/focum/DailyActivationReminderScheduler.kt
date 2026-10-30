package com.focum.app.focum

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.SystemClock

object DailyActivationReminderScheduler {
    private const val REMINDER_INTERVAL_MILLIS = 24 * 60 * 60_000L
    private const val REQUEST_CODE = 4111

    fun schedule(context: Context) {
        val appContext = context.applicationContext
        if (!FocumPrefs.isMonitoringEnabled(appContext)) {
            return
        }

        scheduleNext(appContext)
    }

    fun scheduleNext(context: Context) {
        val appContext = context.applicationContext
        val alarmManager = appContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent(appContext))
        alarmManager.setAndAllowWhileIdle(
            AlarmManager.ELAPSED_REALTIME_WAKEUP,
            SystemClock.elapsedRealtime() + REMINDER_INTERVAL_MILLIS,
            pendingIntent(appContext),
        )
    }

    fun cancel(context: Context) {
        val appContext = context.applicationContext
        val alarmManager = appContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent(appContext))
    }

    private fun pendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, DailyActivationReminderReceiver::class.java)
        return PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }
}
