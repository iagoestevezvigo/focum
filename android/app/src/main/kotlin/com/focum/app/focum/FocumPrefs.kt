package com.focum.app.focum

import android.content.Context

data class ActiveIntention(
    val categoryId: String,
    val reason: String,
    val nextReminderAt: Long,
)

object FocumPrefs {
    private const val PREFS_NAME = "focum_native"
    private const val KEY_MONITORING_ENABLED = "monitoring_enabled"
    private const val KEY_LAST_PROMPT_AT = "last_prompt_at"
    private const val KEY_PENDING_UNLOCK_PROMPT = "pending_unlock_prompt"
    private const val KEY_ACTIVE_INTENTION_CATEGORY = "active_intention_category"
    private const val KEY_ACTIVE_INTENTION_REASON = "active_intention_reason"
    private const val KEY_ACTIVE_INTENTION_NEXT_REMINDER_AT = "active_intention_next_reminder_at"
    private const val KEY_LAST_REMINDER_DELIVERED_AT = "last_reminder_delivered_at"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun isMonitoringEnabled(context: Context): Boolean =
        prefs(context).getBoolean(KEY_MONITORING_ENABLED, false)

    fun setMonitoringEnabled(context: Context, enabled: Boolean) {
        prefs(context).edit().putBoolean(KEY_MONITORING_ENABLED, enabled).apply()
    }

    fun isUnlockPromptPending(context: Context): Boolean =
        prefs(context).getBoolean(KEY_PENDING_UNLOCK_PROMPT, false)

    fun setUnlockPromptPending(context: Context, pending: Boolean) {
        prefs(context).edit().putBoolean(KEY_PENDING_UNLOCK_PROMPT, pending).apply()
    }

    fun activeIntention(context: Context): ActiveIntention? {
        val preferences = prefs(context)
        val categoryId = preferences.getString(KEY_ACTIVE_INTENTION_CATEGORY, null)?.trim().orEmpty()
        val reason = preferences.getString(KEY_ACTIVE_INTENTION_REASON, null)?.trim().orEmpty()
        val nextReminderAt = preferences.getLong(KEY_ACTIVE_INTENTION_NEXT_REMINDER_AT, 0L)
        if (categoryId.isEmpty() || reason.isEmpty()) {
            return null
        }
        return ActiveIntention(
            categoryId = categoryId,
            reason = reason,
            nextReminderAt = nextReminderAt,
        )
    }

    fun setActiveIntention(
        context: Context,
        categoryId: String,
        reason: String,
        nextReminderAt: Long,
    ) {
        prefs(context)
            .edit()
            .putString(KEY_ACTIVE_INTENTION_CATEGORY, categoryId)
            .putString(KEY_ACTIVE_INTENTION_REASON, reason)
            .putLong(KEY_ACTIVE_INTENTION_NEXT_REMINDER_AT, nextReminderAt)
            .apply()
    }

    fun clearActiveIntention(context: Context) {
        prefs(context)
            .edit()
            .remove(KEY_ACTIVE_INTENTION_CATEGORY)
            .remove(KEY_ACTIVE_INTENTION_REASON)
            .remove(KEY_ACTIVE_INTENTION_NEXT_REMINDER_AT)
            .remove(KEY_LAST_REMINDER_DELIVERED_AT)
            .apply()
    }

    fun shouldDeliverReminder(context: Context, now: Long, cooldownMillis: Long = 45_000L): Boolean {
        val lastReminderAt = prefs(context).getLong(KEY_LAST_REMINDER_DELIVERED_AT, 0L)
        if (now - lastReminderAt < cooldownMillis) {
            return false
        }

        prefs(context).edit().putLong(KEY_LAST_REMINDER_DELIVERED_AT, now).apply()
        return true
    }

    fun shouldDispatchPrompt(context: Context, now: Long, cooldownMillis: Long = 1200L): Boolean {
        val lastPromptAt = prefs(context).getLong(KEY_LAST_PROMPT_AT, 0L)
        if (now - lastPromptAt < cooldownMillis) {
            return false
        }

        prefs(context).edit().putLong(KEY_LAST_PROMPT_AT, now).apply()
        return true
    }
}
