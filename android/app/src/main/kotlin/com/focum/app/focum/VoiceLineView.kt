package com.focum.app.focum

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Path
import android.util.AttributeSet
import android.view.View
import android.view.animation.LinearInterpolator
import kotlin.math.PI
import kotlin.math.sin

class VoiceLineView
    @JvmOverloads
    constructor(
        context: Context,
        attrs: AttributeSet? = null,
    ) : View(context, attrs) {
        private val strokePaint =
            Paint(Paint.ANTI_ALIAS_FLAG).apply {
                color = 0xFF8E8E93.toInt()
                style = Paint.Style.STROKE
                strokeWidth = dp(2.4f)
                strokeCap = Paint.Cap.ROUND
                strokeJoin = Paint.Join.ROUND
            }

        private val path = Path()
        private var phase = 0f
        private var listening = false
        private var targetLevel = 0f
        private var displayedLevel = 0f
        private val animator =
            ValueAnimator.ofFloat(0f, 1f).apply {
                duration = 760L
                repeatCount = ValueAnimator.INFINITE
                interpolator = LinearInterpolator()
                addUpdateListener {
                    phase = it.animatedValue as Float
                    displayedLevel += (targetLevel - displayedLevel) * 0.28f
                    invalidate()
                }
            }

        fun setListening(value: Boolean) {
            if (listening == value) {
                return
            }
            listening = value
            if (listening) {
                if (!animator.isStarted) {
                    animator.start()
                }
            } else {
                if (animator.isStarted) {
                    animator.cancel()
                }
                phase = 0f
                targetLevel = 0f
                displayedLevel = 0f
                invalidate()
            }
        }

        fun setSoundLevel(level: Float) {
            targetLevel = level.coerceIn(0f, 1f)
            if (!listening) {
                displayedLevel = 0f
            }
            invalidate()
        }

        override fun onDetachedFromWindow() {
            if (animator.isStarted) {
                animator.cancel()
            }
            super.onDetachedFromWindow()
        }

        override fun onDraw(canvas: Canvas) {
            super.onDraw(canvas)
            val centerY = height / 2f
            val usableWidth = width - paddingLeft - paddingRight
            if (usableWidth <= 0) {
                return
            }

            path.reset()
            val steps = 56
            val startX = paddingLeft.toFloat()
            val amplitude = if (listening) height * (displayedLevel * 0.36f) else 0f

            for (step in 0..steps) {
                val ratio = step / steps.toFloat()
                val x = startX + usableWidth * ratio
                val envelope = 0.14f + (1f - kotlin.math.abs(0.5f - ratio) * 2f) * 0.86f
                val wave =
                    sin((ratio * 6.2f + phase * 2.3f) * (2f * PI).toFloat()) * envelope +
                        sin((ratio * 2.9f + phase * 1.7f) * (2f * PI).toFloat()) * 0.34f
                val y = centerY + amplitude * wave
                if (step == 0) {
                    path.moveTo(x, y)
                } else {
                    path.lineTo(x, y)
                }
            }

            canvas.drawPath(path, strokePaint)
        }

        private fun dp(value: Float): Float = value * resources.displayMetrics.density
    }
