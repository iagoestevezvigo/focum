package com.focum.app.focum

import io.flutter.plugin.common.EventChannel

object PromptEventBridge {
    private var eventSink: EventChannel.EventSink? = null

    fun attach(sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    fun detach() {
        eventSink = null
    }

    fun emitUnlockPrompt() {
        eventSink?.success(NativeEvents.UNLOCK_PROMPT)
    }
}

object NativeEvents {
    const val UNLOCK_PROMPT = "unlock_prompt"
}
