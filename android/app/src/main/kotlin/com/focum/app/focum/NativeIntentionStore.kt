package com.focum.app.focum

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

object NativeIntentionStore {
    private const val PREF_FILE = "FlutterSharedPreferences"
    private const val ENTRIES_KEY = "flutter.focum.entries.v1"
    private const val JSON_LIST_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu!"
    private const val MAX_ENTRIES = 300

    fun saveManualEntry(context: Context, categoryId: String) {
        val reason = reminderReasonFor(context, categoryId, null)
        saveEntry(
            context = context,
            categoryId = categoryId,
            description = null,
            inputMethod = "wheel",
        )
        IntentionAnchorOverlay.show(context, reason)
        IntentionReminderScheduler.schedule(
            context = context,
            categoryId = categoryId,
            reason = reason,
        )
    }

    fun saveVoiceEntry(context: Context, categoryId: String, description: String?) {
        val reason = reminderReasonFor(context, categoryId, description)
        saveEntry(
            context = context,
            categoryId = categoryId,
            description = description,
            inputMethod = "voice",
        )
        IntentionAnchorOverlay.show(context, reason)
        IntentionReminderScheduler.schedule(
            context = context,
            categoryId = categoryId,
            reason = reason,
        )
    }

    private fun saveEntry(
        context: Context,
        categoryId: String,
        description: String?,
        inputMethod: String,
    ) {
        val preferences = context.getSharedPreferences(PREF_FILE, Context.MODE_PRIVATE)
        val entries = loadEntries(preferences)
        entries.add(0, buildEntryJson(categoryId, description, inputMethod))
        val trimmedEntries = entries.take(MAX_ENTRIES)
        val jsonArray = JSONArray()
        for (entry in trimmedEntries) {
            jsonArray.put(entry)
        }
        preferences.edit().putString(ENTRIES_KEY, JSON_LIST_PREFIX + jsonArray.toString()).apply()
    }

    private fun loadEntries(preferences: android.content.SharedPreferences): MutableList<String> {
        val storedValue = preferences.getString(ENTRIES_KEY, null) ?: return mutableListOf()
        if (!storedValue.startsWith(JSON_LIST_PREFIX)) {
            return mutableListOf()
        }

        val rawEntries = storedValue.removePrefix(JSON_LIST_PREFIX)
        val jsonArray = JSONArray(rawEntries)
        val entries = mutableListOf<String>()
        for (index in 0 until jsonArray.length()) {
            entries.add(jsonArray.getString(index))
        }
        return entries
    }

    private fun buildEntryJson(categoryId: String, description: String?, inputMethod: String): String {
        val payload =
            JSONObject().apply {
                put("timestamp", timestampNow())
                put("category", categoryId)
                put("description", description ?: JSONObject.NULL)
                put("inputMethod", inputMethod)
            }
        return payload.toString()
    }

    private fun timestampNow(): String {
        val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", Locale.US)
        return formatter.format(Date())
    }

    private fun reminderReasonFor(context: Context, categoryId: String, description: String?): String {
        val trimmedDescription = description?.trim().orEmpty()
        if (trimmedDescription.isNotEmpty()) {
            return trimmedDescription
        }

        return NativeIntentionClassifier.categories()
            .firstOrNull { it.id == categoryId }
            ?.let { context.getString(it.labelRes) }
            ?.trim()
            .orEmpty()
    }
}
