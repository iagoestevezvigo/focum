package com.focum.app.focum

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Process
import android.provider.Settings
import java.util.Locale

data class ForegroundApp(
    val packageName: String,
    val label: String,
)

object AppUsageMonitor {
    private const val LOOKBACK_MILLIS = 30 * 60_000L

    fun hasUsageAccess(context: Context): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode =
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName,
            )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    fun openUsageAccessSettings(context: Context) {
        val intent = android.content.Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            .addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun currentForegroundApp(context: Context): ForegroundApp? {
        if (!hasUsageAccess(context)) {
            return null
        }

        val usageStatsManager =
            context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val now = System.currentTimeMillis()
        val events = usageStatsManager.queryEvents(now - LOOKBACK_MILLIS, now)
        val event = UsageEvents.Event()
        var latestPackage: String? = null

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            val movedToForeground =
                event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND ||
                    (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q &&
                        event.eventType == UsageEvents.Event.ACTIVITY_RESUMED)
            if (movedToForeground) {
                latestPackage = event.packageName
            }
        }

        val packageName = latestPackage ?: latestPackageFromStats(usageStatsManager, now) ?: return null
        if (packageName == context.packageName) {
            val statsPackage = latestPackageFromStats(usageStatsManager, now)
            if (statsPackage == null || statsPackage == context.packageName) {
                return null
            }
            return ForegroundApp(
                packageName = statsPackage,
                label = appLabel(context, statsPackage),
            )
        }

        return ForegroundApp(
            packageName = packageName,
            label = appLabel(context, packageName),
        )
    }

    private fun latestPackageFromStats(
        usageStatsManager: UsageStatsManager,
        now: Long,
    ): String? {
        return usageStatsManager
            .queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                now - LOOKBACK_MILLIS,
                now,
            )
            .maxByOrNull { stats -> stats.lastTimeUsed }
            ?.packageName
    }

    private fun appLabel(context: Context, packageName: String): String {
        return try {
            val packageManager = context.packageManager
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(appInfo).toString()
        } catch (_: PackageManager.NameNotFoundException) {
            packageName
        } catch (_: RuntimeException) {
            packageName
        }
    }
}

object AppIntentMatcher {
    fun matches(
        context: Context,
        categoryId: String,
        foregroundApp: ForegroundApp,
    ): Boolean {
        val packageName = foregroundApp.packageName.lowercase(Locale.US)
        val label = foregroundApp.label.lowercase(Locale.getDefault())
        val searchable = "$packageName $label"

        if (isNeutralApp(context, packageName, searchable)) {
            return true
        }

        val keywords = keywordsFor(categoryId)
        if (keywords.isEmpty()) {
            return true
        }

        return keywords.any { keyword -> searchable.contains(keyword) }
    }

    private fun isNeutralApp(
        context: Context,
        packageName: String,
        searchable: String,
    ): Boolean {
        if (packageName == context.packageName) {
            return true
        }

        val neutralTerms =
            listOf(
                "launcher",
                "settings",
                "systemui",
                "permission",
                "installer",
                "inputmethod",
                "keyboard",
                "home",
            )
        return packageName.startsWith("android") ||
            packageName.startsWith("com.android") ||
            neutralTerms.any { searchable.contains(it) }
    }

    private fun keywordsFor(categoryId: String): List<String> =
        when (categoryId) {
            "learning" ->
                listOf(
                    "classroom",
                    "duolingo",
                    "coursera",
                    "udemy",
                    "kindle",
                    "books",
                    "read",
                    "reader",
                    "docs",
                    "notion",
                    "anki",
                    "learn",
                    "study",
                )
            "work" ->
                listOf(
                    "slack",
                    "teams",
                    "outlook",
                    "gmail",
                    "calendar",
                    "drive",
                    "docs",
                    "sheets",
                    "notion",
                    "linear",
                    "github",
                    "jira",
                    "zoom",
                    "work",
                )
            "personal_growth" ->
                listOf(
                    "calm",
                    "headspace",
                    "meditation",
                    "meditar",
                    "journal",
                    "diary",
                    "notes",
                    "keep",
                    "habit",
                    "mindfulness",
                    "notion",
                )
            "social" ->
                listOf(
                    "whatsapp",
                    "instagram",
                    "tiktok",
                    "facebook",
                    "twitter",
                    "threads",
                    "snapchat",
                    "bereal",
                    "telegram",
                    "signal",
                    "messages",
                    "phone",
                    "contacts",
                    "discord",
                    "messenger",
                    "x.",
                    "social",
                    "chat",
                    "call",
                )
            "health" ->
                listOf(
                    "fit",
                    "health",
                    "salud",
                    "fitness",
                    "strava",
                    "garmin",
                    "nike",
                    "workout",
                    "gym",
                    "sleep",
                )
            "travel" ->
                listOf(
                    "maps",
                    "uber",
                    "cabify",
                    "booking",
                    "airbnb",
                    "flight",
                    "airline",
                    "train",
                    "renfe",
                    "trip",
                    "travel",
                )
            "personal" ->
                listOf(
                    "calendar",
                    "bank",
                    "wallet",
                    "pay",
                    "amazon",
                    "shopping",
                    "mercadona",
                    "notes",
                    "keep",
                    "home",
                )
            else -> emptyList()
        }
}
