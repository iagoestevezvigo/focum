package com.focum.app.focum

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.PixelFormat
import android.media.AudioManager
import android.media.ToneGenerator
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log
import android.view.Gravity
import android.view.HapticFeedbackConstants
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import java.util.Locale

class UnlockPromptOverlay(
    private val context: Context,
) {
    companion object {
        private const val TAG = "Focum"
    }

    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val mainHandler = Handler(Looper.getMainLooper())

    private var overlayView: FrameLayout? = null
    private var contentContainer: LinearLayout? = null
    private var voiceContainer: LinearLayout? = null
    private var manualContainer: ManualWheelView? = null
    private var bottomRow: LinearLayout? = null
    private var toggleButton: TextView? = null
    private var subtitleView: TextView? = null
    private var hintView: TextView? = null
    private var listenButton: FocumListenButtonView? = null
    private var waveView: VoiceLineView? = null
    private var speechRecognizer: SpeechRecognizer? = null
    private var voiceTone: ToneGenerator? = null
    private var speechRecognitionAvailable: Boolean? = null
    private var isShowing = false
    private var isVoiceMode = true
    private var isProcessingVoice = false
    private var isStoppingRecognizer = false
    private var isRecognizerActive = false
    private var latestHeardTranscript: String? = null
    private var latestHeardAt = 0L

    private val manualCategories =
        NativeIntentionClassifier.categories().filterNot { it.id == "other" }
    private val speechResetRunnable =
        Runnable {
            waveView?.setSoundLevel(0f)
            listenButton?.setSoundLevel(0f)
        }
    private val partialCommitRunnable =
        Runnable {
            submitLatestTranscriptIfFresh()
        }

    fun prepare() {
        mainHandler.post {
            ensureOverlayView()
            attachOverlayIfNeeded(visible = false)
            ensureSpeechRecognizer()
        }
    }

    fun show() {
        mainHandler.post {
            ensureOverlayView()
            if (!attachOverlayIfNeeded(visible = true)) {
                dismissInternal(removeOverlay = true)
                return@post
            }
            overlayView?.let { applyImmersiveMode(it) }
            isShowing = true
            switchToVoiceMode()
        }
    }

    fun dismiss() {
        mainHandler.post { dismissInternal() }
    }

    fun release() {
        mainHandler.post { dismissInternal(destroyRecognizer = true, removeOverlay = true) }
    }

    fun refreshConfiguration() {
        mainHandler.post {
            val wasShowing = isShowing
            dismissInternal(destroyRecognizer = true, removeOverlay = true)
            overlayView = null
            manualContainer = null
            ensureOverlayView()
            attachOverlayIfNeeded(visible = wasShowing)
            ensureSpeechRecognizer()
            if (wasShowing) {
                isShowing = true
                switchToVoiceMode()
            }
        }
    }

    private fun dismissInternal(
        destroyRecognizer: Boolean = false,
        removeOverlay: Boolean = false,
    ) {
        stopListening(destroyRecognizer = destroyRecognizer)
        mainHandler.removeCallbacks(speechResetRunnable)
        mainHandler.removeCallbacks(partialCommitRunnable)
        waveView?.setListening(false)
        waveView?.setSoundLevel(0f)
        listenButton?.setProcessing(false)
        listenButton?.setListening(false)
        listenButton?.setSoundLevel(0f)
        latestHeardTranscript = null
        latestHeardAt = 0L
        isVoiceMode = true
        isProcessingVoice = false
        isShowing = false
        setOverlayVisible(false)
        val currentView = overlayView
        if (removeOverlay && currentView?.parent != null) {
            windowManager.removeViewImmediate(currentView)
        }
    }

    private fun ensureOverlayView() {
        if (overlayView != null) {
            return
        }

        val root =
            FrameLayout(context).apply {
                setBackgroundColor(0xFFF7F7F4.toInt())
                isClickable = true
                isFocusable = true
                applyImmersiveMode(this)
            }

        val content =
            LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.CENTER_HORIZONTAL
                setPadding(dp(24), dp(24), dp(24), dp(24))
            }
        contentContainer = content

        val contentParams =
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
            )
        root.addView(content, contentParams)

        val topRow =
            LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.CENTER
            }
        content.addView(
            topRow,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ),
        )

        val title =
            TextView(context).apply {
                text = context.getString(R.string.intention_question)
                setTextColor(0xFF1C1C1E.toInt())
                textSize = 19f
                gravity = Gravity.CENTER
            }
        topRow.addView(
            title,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ),
        )

        subtitleView =
            TextView(context).apply {
                setTextColor(0xFF6E6E73.toInt())
                textSize = 13f
                gravity = Gravity.CENTER
            }
        topRow.addView(
            subtitleView,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply {
                topMargin = dp(8)
            },
        )

        voiceContainer =
            LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.CENTER_HORIZONTAL
                setPadding(0, 0, 0, dp(8))
            }
        content.addView(
            voiceContainer,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f,
            ),
        )

        voiceContainer?.addView(
            View(context),
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f,
            ),
        )

        waveView =
            VoiceLineView(context).apply {
                setPadding(dp(4), dp(4), dp(4), dp(4))
                visibility = View.GONE
            }
        voiceContainer?.addView(
            waveView,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dp(92),
            ),
        )

        listenButton =
            FocumListenButtonView(context).apply {
                setOnClickListener {
                    if (isProcessingVoice) {
                        return@setOnClickListener
                    }
                    if (isRecognizerActive) {
                        stopListening()
                    } else {
                        playVoiceStartFeedback()
                        startListening()
                    }
                }
            }
        voiceContainer?.addView(
            listenButton,
            LinearLayout.LayoutParams(dp(211), dp(211)).apply {
                topMargin = dp(0)
            },
        )

        hintView =
            TextView(context).apply {
                text = context.getString(R.string.voice_idle_hint)
                setTextColor(0xFF8E8E93.toInt())
                textSize = 13f
                gravity = Gravity.CENTER
                setPadding(0, dp(10), 0, 0)
            }
        voiceContainer?.addView(hintView)

        voiceContainer?.addView(
            View(context),
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f,
            ),
        )

        val bottomControls =
            LinearLayout(context).apply {
                orientation = LinearLayout.HORIZONTAL
                gravity = Gravity.END
                setPadding(0, dp(8), 0, 0)
            }
        bottomRow = bottomControls
        content.addView(
            bottomControls,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ),
        )

        toggleButton =
            TextView(context).apply {
                text = context.getString(R.string.manual_mode)
                setTextColor(0xFF666763.toInt())
                textSize = 13f
                gravity = Gravity.END
                setPadding(dp(8), dp(6), 0, dp(6))
                setOnClickListener {
                    if (isVoiceMode) {
                        switchToManualMode()
                    } else {
                        switchToVoiceMode()
                    }
                }
            }
        bottomControls.addView(toggleButton)

        overlayView = root
        updatePromptCopy()
    }

    private fun attachOverlayIfNeeded(visible: Boolean): Boolean {
        val view = overlayView ?: return false
        if (view.parent != null) {
            setOverlayVisible(visible)
            return true
        }

        view.visibility = if (visible) View.VISIBLE else View.GONE
        return try {
            windowManager.addView(view, buildLayoutParams(visible))
            if (visible) {
                applyImmersiveMode(view)
            }
            true
        } catch (error: RuntimeException) {
            Log.e(TAG, "Unable to attach unlock overlay", error)
            false
        }
    }

    private fun setOverlayVisible(visible: Boolean) {
        val view = overlayView ?: return
        if (view.parent == null) {
            view.visibility = if (visible) View.VISIBLE else View.GONE
            return
        }

        val params = view.layoutParams as? WindowManager.LayoutParams ?: return
        params.flags = overlayFlags(visible)
        params.alpha = if (visible) 1f else 0f
        if (visible) {
            view.visibility = View.VISIBLE
            applyImmersiveMode(view)
        }
        try {
            windowManager.updateViewLayout(view, params)
            if (!visible) {
                view.visibility = View.GONE
            }
        } catch (error: RuntimeException) {
            Log.e(TAG, "Unable to update unlock overlay visibility", error)
        }
    }

    private fun buildLayoutParams(visible: Boolean): WindowManager.LayoutParams {
        val overlayType =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                @Suppress("DEPRECATION")
                WindowManager.LayoutParams.TYPE_PHONE
            }

        return WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            overlayType,
            overlayFlags(visible),
            PixelFormat.TRANSLUCENT,
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            alpha = if (visible) 1f else 0f
            screenBrightness = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                layoutInDisplayCutoutMode =
                    WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
            }
        }
    }

    private fun overlayFlags(visible: Boolean): Int {
        val baseFlags =
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS or
                WindowManager.LayoutParams.FLAG_FULLSCREEN or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        return if (visible) {
            baseFlags
        } else {
            baseFlags or
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
        }
    }

    private fun applyImmersiveMode(view: View) {
        view.systemUiVisibility =
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
                View.SYSTEM_UI_FLAG_FULLSCREEN or
                View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
        view.requestFocus()
    }

    private fun ensureManualContainer(): ManualWheelView {
        manualContainer?.let { return it }
        val content =
            contentContainer
                ?: throw IllegalStateException("Overlay content must exist before manual mode")
        val manual =
            ManualWheelView(context).apply {
                visibility = View.GONE
                setCategories(manualCategories)
                onCategoryChosen = { category ->
                    NativeIntentionStore.saveManualEntry(context, category.id)
                    dismissInternal()
                }
            }
        val insertIndex =
            bottomRow
                ?.let { content.indexOfChild(it) }
                ?.takeIf { it >= 0 }
                ?: content.childCount
        content.addView(
            manual,
            insertIndex,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f,
            ),
        )
        manualContainer = manual
        return manual
    }

    private fun switchToVoiceMode() {
        isVoiceMode = true
        voiceContainer?.visibility = View.VISIBLE
        manualContainer?.visibility = View.GONE
        toggleButton?.text = context.getString(R.string.manual_mode)
        manualContainer?.resetSelection()
        updatePromptCopy()
        resetVoiceIdleUi()
    }

    private fun switchToManualMode() {
        isVoiceMode = false
        stopListening()
        val manual = ensureManualContainer()
        waveView?.setListening(false)
        waveView?.setSoundLevel(0f)
        voiceContainer?.visibility = View.GONE
        manual.visibility = View.VISIBLE
        toggleButton?.text = context.getString(R.string.voice_mode)
        manual.resetSelection()
        updatePromptCopy()
    }

    private fun isSpeechRecognitionAvailable(): Boolean {
        speechRecognitionAvailable?.let { return it }
        return OnDeviceVoice.available(context).also {
            speechRecognitionAvailable = it
        }
    }

    private fun ensureSpeechRecognizer(): SpeechRecognizer? {
        if (!isSpeechRecognitionAvailable()) {
            return null
        }
        speechRecognizer?.let { return it }
        return try {
            OnDeviceVoice.create(context)?.also {
                it.setRecognitionListener(buildRecognitionListener())
                speechRecognizer = it
            }
        } catch (error: RuntimeException) {
            Log.e(TAG, "Speech recognizer failed to prepare", error)
            null
        }
    }

    private fun startListening() {
        if (!isShowing || !isVoiceMode) {
            return
        }
        if (isRecognizerActive) {
            return
        }
        if (!PrivacyConsent.granted(context, "microphone") || !hasMicrophonePermission()) {
            Log.w(TAG, "Microphone permission missing for overlay prompt")
            switchToManualMode()
            return
        }
        val recognizer = ensureSpeechRecognizer()
        if (recognizer == null) {
            Log.w(TAG, "Speech recognition unavailable for overlay prompt")
            switchToManualMode()
            return
        }

        mainHandler.removeCallbacks(speechResetRunnable)
        mainHandler.removeCallbacks(partialCommitRunnable)
        latestHeardTranscript = null
        latestHeardAt = 0L

        isStoppingRecognizer = false
        isRecognizerActive = true
        isProcessingVoice = false
        hintView?.text = context.getString(R.string.listening)
        waveView?.visibility = View.GONE
        waveView?.setListening(false)
        waveView?.setSoundLevel(0f)
        listenButton?.visibility = View.VISIBLE
        listenButton?.setProcessing(false)
        listenButton?.setListening(true)
        listenButton?.setSoundLevel(0f)
        try {
            recognizer.startListening(buildRecognizerIntent())
        } catch (error: RuntimeException) {
            isRecognizerActive = false
            Log.e(TAG, "Speech recognizer failed to start", error)
            resetVoiceIdleUi()
        }
    }

    private fun stopListening(destroyRecognizer: Boolean = false) {
        mainHandler.removeCallbacks(speechResetRunnable)
        mainHandler.removeCallbacks(partialCommitRunnable)
        isStoppingRecognizer = true
        isRecognizerActive = false
        isProcessingVoice = false
        speechRecognizer?.cancel()
        waveView?.setListening(false)
        waveView?.setSoundLevel(0f)
        listenButton?.setProcessing(false)
        listenButton?.setListening(false)
        listenButton?.setSoundLevel(0f)
        latestHeardTranscript = null
        latestHeardAt = 0L
        if (destroyRecognizer) {
            releaseVoiceFeedback()
        }

        if (destroyRecognizer) {
            speechRecognizer?.destroy()
            speechRecognizer = null
        } else {
            resetVoiceIdleUi()
        }
    }

    private fun playVoiceStartFeedback() {
        listenButton?.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK)
        try {
            val tone =
                voiceTone ?: ToneGenerator(AudioManager.STREAM_MUSIC, 18).also {
                    voiceTone = it
                }
            tone.startTone(ToneGenerator.TONE_PROP_ACK, 55)
        } catch (error: RuntimeException) {
            Log.w(TAG, "Unable to play voice start feedback", error)
        }
    }

    private fun releaseVoiceFeedback() {
        voiceTone?.release()
        voiceTone = null
    }

    private fun buildRecognizerIntent(): Intent =
        Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(
                RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM,
            )
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, context.resources.configuration.locales[0].toLanguageTag())
            putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_MINIMUM_LENGTH_MILLIS, 8000)
            putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 2400)
            putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_POSSIBLY_COMPLETE_SILENCE_LENGTH_MILLIS, 1800)
        }

    private fun buildRecognitionListener() =
        object : RecognitionListener {
            override fun onReadyForSpeech(params: Bundle?) {
                hintView?.text = context.getString(R.string.listening)
            }

            override fun onBeginningOfSpeech() = Unit

            override fun onRmsChanged(rmsdB: Float) {
                if (isProcessingVoice) {
                    return
                }
                pulseSpeechActivity(rmsdB)
            }

            override fun onBufferReceived(buffer: ByteArray?) = Unit

            override fun onEndOfSpeech() {
                waveView?.setSoundLevel(0f)
                showProcessingUi()
                if (!latestHeardTranscript.isNullOrBlank()) {
                    schedulePartialCommit(900L)
                }
            }

            override fun onError(error: Int) {
                isRecognizerActive = false
                waveView?.setListening(false)
                waveView?.setSoundLevel(0f)
                listenButton?.setProcessing(false)
                listenButton?.setListening(false)
                listenButton?.setSoundLevel(0f)
                isProcessingVoice = false
                if (!isShowing || !isVoiceMode) {
                    return
                }
                if (isStoppingRecognizer) {
                    isStoppingRecognizer = false
                    return
                }

                if (shouldCommitLatestTranscript()) {
                    submitLatestTranscriptIfFresh()
                    return
                }

                switchToManualMode()
            }

            override fun onResults(results: Bundle?) {
                isRecognizerActive = false
                mainHandler.removeCallbacks(partialCommitRunnable)
                val transcript = bestTranscript(results)
                if (transcript.isNullOrBlank()) {
                    resetVoiceIdleUi(context.getString(R.string.voice_retry_hint))
                    return
                }
                submitVoiceTranscript(transcript)
            }

            override fun onPartialResults(partialResults: Bundle?) {
                val transcript = extractTranscript(partialResults)
                if (!transcript.isNullOrBlank()) {
                    rememberTranscript(transcript)
                    pulseSpeechActivity(6f)
                }
            }

            override fun onEvent(eventType: Int, params: Bundle?) = Unit
        }

    private fun extractTranscript(bundle: Bundle?): String? {
        val matches = bundle?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION) ?: return null
        return matches.firstOrNull { it.isNotBlank() }?.trim()
    }

    private fun submitVoiceTranscript(transcript: String) {
        val category = NativeIntentionClassifier.classify(transcript)
        NativeIntentionStore.saveVoiceEntry(
            context = context,
            categoryId = category.id,
            description = cleanDescription(transcript),
        )
        dismissInternal()
    }

    private fun pulseSpeechActivity(rmsdB: Float) {
        val normalizedLevel = ((rmsdB - 2f) / 8f).coerceIn(0f, 1f)
        waveView?.setSoundLevel(normalizedLevel)
        listenButton?.setSoundLevel(normalizedLevel)
        waveView?.visibility = View.GONE
        mainHandler.removeCallbacks(speechResetRunnable)
        if (normalizedLevel > 0f) {
            mainHandler.postDelayed(speechResetRunnable, 480L)
        }
    }

    private fun rememberTranscript(transcript: String) {
        val cleanedTranscript = cleanDescription(transcript) ?: return
        latestHeardTranscript = cleanedTranscript
        latestHeardAt = SystemClock.elapsedRealtime()
        schedulePartialCommit(2200L)
    }

    private fun schedulePartialCommit(delayMillis: Long) {
        mainHandler.removeCallbacks(partialCommitRunnable)
        mainHandler.postDelayed(partialCommitRunnable, delayMillis)
    }

    private fun shouldCommitLatestTranscript(): Boolean {
        val transcript = latestHeardTranscript ?: return false
        if (transcript.isBlank()) {
            return false
        }
        return SystemClock.elapsedRealtime() - latestHeardAt < 5000L
    }

    private fun submitLatestTranscriptIfFresh() {
        if (!isShowing || !isVoiceMode || !shouldCommitLatestTranscript()) {
            resetVoiceIdleUi(context.getString(R.string.voice_retry_hint))
            return
        }
        isRecognizerActive = false
        val transcript = latestHeardTranscript ?: return
        submitVoiceTranscript(transcript)
    }

    private fun bestTranscript(results: Bundle?): String? {
        val directTranscript = extractTranscript(results)
        if (!directTranscript.isNullOrBlank()) {
            return cleanDescription(directTranscript)
        }
        return latestHeardTranscript
    }

    private fun cleanDescription(value: String): String? {
        val trimmed = value.trim()
        if (trimmed.isEmpty()) {
            return null
        }
        val first = trimmed.substring(0, 1).uppercase(Locale.getDefault())
        return if (trimmed.length == 1) first else first + trimmed.substring(1)
    }

    private fun hasMicrophonePermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.RECORD_AUDIO,
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun resetVoiceIdleUi(message: String = context.getString(R.string.voice_idle_hint)) {
        isRecognizerActive = false
        isProcessingVoice = false
        hintView?.text = message
        waveView?.setListening(false)
        waveView?.setSoundLevel(0f)
        waveView?.visibility = View.GONE
        listenButton?.setProcessing(false)
        listenButton?.setListening(false)
        listenButton?.setSoundLevel(0f)
        listenButton?.visibility = View.VISIBLE
        updateListenButton()
    }

    private fun showProcessingUi() {
        isProcessingVoice = true
        hintView?.text = ""
        waveView?.setListening(false)
        waveView?.setSoundLevel(0f)
        waveView?.visibility = View.GONE
        listenButton?.visibility = View.VISIBLE
        listenButton?.setProcessing(true)
        listenButton?.setListening(false)
        listenButton?.setSoundLevel(0f)
    }

    private fun updateListenButton() {
        listenButton?.setProcessing(false)
        listenButton?.setListening(false)
        listenButton?.setSoundLevel(0f)
    }

    private fun updatePromptCopy() {
        subtitleView?.text =
            if (isVoiceMode) {
                context.getString(R.string.say_before_entering)
            } else {
                context.getString(R.string.choose_before_entering)
            }
    }

    private fun dp(value: Int): Int = (value * context.resources.displayMetrics.density).toInt()
}
