package com.focum.app.focum

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.os.SystemClock

object IntentionReminderScheduler {
    const val EXTRA_REASON = "extra_reason"
    const val EXTRA_CATEGORY_ID = "extra_category_id"
    const val EXTRA_REQUEST_CODE = "extra_request_code"
    private const val REMINDER_INTERVAL_MILLIS = 5 * 60_000L
    private const val REQUEST_CODE = 4108
    private val mainHandler = Handler(Looper.getMainLooper())
    private var reminderRunnable: Runnable? = null

    fun schedule(context: Context, categoryId: String, reason: String) {
        val cleanedReason = reason.trim()
        val cleanedCategoryId = categoryId.trim()
        if (cleanedReason.isEmpty() || cleanedCategoryId.isEmpty()) {
            return
        }

        val appContext = context.applicationContext
        val nextReminderAt = System.currentTimeMillis() + REMINDER_INTERVAL_MILLIS
        FocumPrefs.setActiveIntention(
            context = appContext,
            categoryId = cleanedCategoryId,
            reason = cleanedReason,
            nextReminderAt = nextReminderAt,
        )
        schedulePending(appContext, cleanedCategoryId, cleanedReason, REMINDER_INTERVAL_MILLIS)
    }

    fun restore(context: Context) {
        val appContext = context.applicationContext
        val activeIntention = FocumPrefs.activeIntention(appContext) ?: return
        if (!FocumPrefs.isMonitoringEnabled(appContext)) {
            return
        }

        IntentionAnchorOverlay.show(appContext, activeIntention.reason)
        val delayMillis = (activeIntention.nextReminderAt - System.currentTimeMillis())
            .coerceAtLeast(0L)
        schedulePending(
            context = appContext,
            categoryId = activeIntention.categoryId,
            reason = activeIntention.reason,
            delayMillis = delayMillis,
        )
    }

    private fun schedulePending(
        context: Context,
        categoryId: String,
        reason: String,
        delayMillis: Long,
    ) {
        cancelPending()
        scheduleAlarm(context, categoryId, reason, delayMillis)
        reminderRunnable =
            Runnable {
                val delivered =
                    IntentionReminderReceiver.showReminder(
                        context = context,
                        reason = reason,
                        categoryId = categoryId,
                        requestCode = REQUEST_CODE,
                    )
                if (delivered) {
                    schedule(context, categoryId, reason)
                }
            }.also { runnable ->
                mainHandler.postDelayed(runnable, delayMillis)
            }
    }

    private fun scheduleAlarm(
        context: Context,
        categoryId: String,
        reason: String,
        delayMillis: Long,
    ) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val triggerAt = SystemClock.elapsedRealtime() + delayMillis
        alarmManager.cancel(pendingIntent(context))
        alarmManager.setAndAllowWhileIdle(
            AlarmManager.ELAPSED_REALTIME_WAKEUP,
            triggerAt,
            pendingIntent(context, categoryId, reason),
        )
    }

    fun triggerNow(context: Context, categoryId: String, reason: String) {
        val cleanedReason = reason.trim()
        val cleanedCategoryId = categoryId.trim()
        if (cleanedReason.isEmpty() || cleanedCategoryId.isEmpty()) {
            return
        }

        IntentionReminderReceiver.showReminder(
            context = context.applicationContext,
            reason = cleanedReason,
            categoryId = cleanedCategoryId,
            requestCode = REQUEST_CODE,
        )
    }

    fun cancel(context: Context) {
        cancelPending()
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent(context.applicationContext))
        FocumPrefs.clearActiveIntention(context.applicationContext)
    }

    private fun cancelPending() {
        reminderRunnable?.let { mainHandler.removeCallbacks(it) }
        reminderRunnable = null
    }

    fun extractReason(intent: Intent): String {
        return intent.getStringExtra(EXTRA_REASON)?.trim().orEmpty()
    }

    fun extractCategoryId(intent: Intent): String {
        return intent.getStringExtra(EXTRA_CATEGORY_ID)?.trim().orEmpty()
    }

    fun extractRequestCode(intent: Intent): Int {
        return intent.getIntExtra(EXTRA_REQUEST_CODE, REQUEST_CODE)
    }

    private fun pendingIntent(
        context: Context,
        categoryId: String? = null,
        reason: String? = null,
    ): PendingIntent {
        val intent =
            Intent(context, IntentionReminderReceiver::class.java).apply {
                categoryId?.let { putExtra(EXTRA_CATEGORY_ID, it) }
                reason?.let { putExtra(EXTRA_REASON, it) }
                putExtra(EXTRA_REQUEST_CODE, REQUEST_CODE)
            }
        return PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }
}
