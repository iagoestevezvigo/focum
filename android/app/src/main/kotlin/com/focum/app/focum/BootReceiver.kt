package com.focum.app.focum

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val action = intent?.action
        Log.d("Focum", "BootReceiver.onReceive action=$action monitoring=${FocumPrefs.isMonitoringEnabled(context)}")
        if (!FocumPrefs.isMonitoringEnabled(context)) {
            return
        }

        if (action == Intent.ACTION_BOOT_COMPLETED ||
            action == Intent.ACTION_LOCKED_BOOT_COMPLETED ||
            action == Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            DailyActivationReminderScheduler.schedule(context)
            UnlockMonitorService.start(context)
        }
    }
}
