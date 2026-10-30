package com.focum.app.focum

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import io.flutter.plugin.common.MethodChannel

object PrivacyConsent {
    private const val PREFS = "focum_privacy_v1"

    fun granted(context: Context, kind: String): Boolean =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getBoolean(kind, false)

    fun request(activity: Activity, kind: String, result: MethodChannel.Result) {
        val message = when (kind) {
            "microphone" -> R.string.microphone_disclosure
            "usage" -> R.string.usage_disclosure
            else -> { result.error("invalid_consent", "Unknown consent", null); return }
        }
        if (granted(activity, kind)) { result.success(true); return }
        AlertDialog.Builder(activity)
            .setTitle(R.string.privacy_title)
            .setMessage(message)
            .setPositiveButton(R.string.consent_accept) { _, _ ->
                activity.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                    .edit().putBoolean(kind, true).apply()
                result.success(true)
            }
            .setNegativeButton(R.string.consent_decline) { _, _ -> result.success(false) }
            .setOnCancelListener { result.success(false) }
            .show()
    }
}
