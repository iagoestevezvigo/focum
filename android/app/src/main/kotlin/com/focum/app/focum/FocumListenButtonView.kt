package com.focum.app.focum

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.os.SystemClock
import android.util.AttributeSet
import android.view.View
import kotlin.math.abs

class FocumListenButtonView
    @JvmOverloads
    constructor(
        context: Context,
        attrs: AttributeSet? = null,
    ) : View(context, attrs) {
        private val markRingPaint =
            Paint(Paint.ANTI_ALIAS_FLAG).apply {
                style = Paint.Style.STROKE
                strokeCap = Paint.Cap.ROUND
                color = 0x8A5F766F.toInt()
                strokeWidth = dp(2f)
            }

        private val markDotPaint =
            Paint(Paint.ANTI_ALIAS_FLAG).apply {
                style = Paint.Style.FILL
                color = 0xFFC94B42.toInt()
            }

        private var targetSoundLevel = 0f
        private var displayedSoundLevel = 0f
        private var listening = false
        private var processing = false

        init {
            isClickable = true
            isFocusable = true
        }

        override fun setPressed(pressed: Boolean) {
            super.setPressed(pressed)
            invalidate()
        }

        fun setListening(value: Boolean) {
            listening = value
            if (!listening) {
                targetSoundLevel = 0f
            }
            invalidate()
        }

        fun setProcessing(value: Boolean) {
            processing = value
            if (processing) {
                listening = false
                targetSoundLevel = 0f
            }
            invalidate()
        }

        fun setSoundLevel(level: Float) {
            targetSoundLevel = level.coerceIn(0f, 1f)
            invalidate()
        }

        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            val size = dp(211f).toInt()
            setMeasuredDimension(
                resolveSize(size, widthMeasureSpec),
                resolveSize(size, heightMeasureSpec),
            )
        }

        override fun onDraw(canvas: Canvas) {
            super.onDraw(canvas)
            val centerX = width / 2f
            val centerY = height / 2f
            val targetLevel = if (listening && !processing) targetSoundLevel else 0f
            displayedSoundLevel += (targetLevel - displayedSoundLevel) * 0.14f
            if (abs(targetLevel - displayedSoundLevel) > 0.01f) {
                postInvalidateOnAnimation()
            }

            val level = displayedSoundLevel
            val pressGrowth = if (listening || processing || isPressed) 1f else 0f
            val ringRadius = dp(43.875f + pressGrowth * 13.1625f + level * 39f)

            markRingPaint.strokeWidth = dp(5.85f + pressGrowth * 0.8775f + level * 3.51f)
            markRingPaint.color =
                alphaColor(
                    0xFF5F766F.toInt(),
                    0.4f + pressGrowth * 0.12f + level * 0.2f,
                )
            if (processing) {
                val bounds =
                    RectF(
                        centerX - ringRadius,
                        centerY - ringRadius,
                        centerX + ringRadius,
                        centerY + ringRadius,
                    )
                val startAngle = (SystemClock.uptimeMillis() % 1400L) / 1400f * 360f
                canvas.drawArc(bounds, startAngle, 104f, false, markRingPaint)
                postInvalidateOnAnimation()
            } else {
                canvas.drawCircle(centerX, centerY, ringRadius, markRingPaint)
            }
            canvas.drawCircle(centerX, centerY, dp(14.625f + pressGrowth * 5.85f), markDotPaint)
        }

        private fun alphaColor(color: Int, alpha: Float): Int {
            val resolvedAlpha = (alpha.coerceIn(0f, 1f) * 255).toInt()
            return Color.argb(
                resolvedAlpha,
                Color.red(color),
                Color.green(color),
                Color.blue(color),
            )
        }

        private fun dp(value: Float): Float = value * resources.displayMetrics.density
    }
