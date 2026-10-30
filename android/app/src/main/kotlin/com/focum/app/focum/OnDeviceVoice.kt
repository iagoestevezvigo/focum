package com.focum.app.focum

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** Never creates the default recognizer: unsupported devices stay in manual mode. */
class OnDeviceVoice(private val context: Context, engine: FlutterEngine) : RecognitionListener {
    companion object {
        fun available(context: Context): Boolean = try {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                SpeechRecognizer.isOnDeviceRecognitionAvailable(context)
        } catch (_: RuntimeException) { false }

        fun create(context: Context): SpeechRecognizer? =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && available(context))
                SpeechRecognizer.createOnDeviceSpeechRecognizer(context) else null
    }

    private var recognizer: SpeechRecognizer? = null
    private var events: EventChannel.EventSink? = null
    private val methods = MethodChannel(engine.dartExecutor.binaryMessenger, "focum/speech")
    private val stream = EventChannel(engine.dartExecutor.binaryMessenger, "focum/speech_events")

    init {
        stream.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) { events = sink }
            override fun onCancel(arguments: Any?) { stop(); events = null }
        })
        methods.setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    if (!PrivacyConsent.granted(context, "microphone") ||
                        ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED ||
                        !available(context)) {
                        result.success(false)
                    } else {
                        try {
                            stop()
                            recognizer = create(context)?.also { it.setRecognitionListener(this) }
                            val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                                putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                                putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
                                putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, true)
                                putExtra(RecognizerIntent.EXTRA_LANGUAGE, context.resources.configuration.locales[0].toLanguageTag())
                            }
                            recognizer?.startListening(intent)
                            result.success(recognizer != null)
                        } catch (_: RuntimeException) {
                            stop()
                            result.success(false)
                        }
                    }
                }
                "stop" -> { stop(); result.success(null) }
                else -> result.notImplemented()
            }
        }
    }

    private fun send(value: Map<String, Any>) { events?.success(value) }
    private fun stop() {
        recognizer?.cancel()
        recognizer?.destroy()
        recognizer = null
    }
    fun dispose() { stop(); events = null; methods.setMethodCallHandler(null); stream.setStreamHandler(null) }
    override fun onReadyForSpeech(params: Bundle?) = Unit
    override fun onBeginningOfSpeech() = Unit
    override fun onRmsChanged(rmsdB: Float) { send(mapOf("level" to rmsdB.toDouble())) }
    override fun onBufferReceived(buffer: ByteArray?) = Unit
    override fun onEndOfSpeech() = Unit
    override fun onError(error: Int) { send(mapOf("error" to "speech_error_$error")) }
    override fun onResults(results: Bundle?) { transcript(results, true) }
    override fun onPartialResults(partialResults: Bundle?) { transcript(partialResults, false) }
    override fun onEvent(eventType: Int, params: Bundle?) = Unit
    private fun transcript(bundle: Bundle?, isFinal: Boolean) {
        val text = bundle?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)?.firstOrNull().orEmpty()
        send(mapOf("text" to text, "final" to isFinal))
    }
}
