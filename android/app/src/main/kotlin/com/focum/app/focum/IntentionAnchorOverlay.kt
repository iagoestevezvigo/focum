package com.focum.app.focum

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.TextView

object IntentionAnchorOverlay {
    private val mainHandler = Handler(Looper.getMainLooper())
    private var activeView: View? = null
    private var activeReason: String? = null

    fun show(context: Context, reason: String) {
        val cleanedReason = reason.trim()
        if (cleanedReason.isEmpty()) {
            dismiss(context)
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(context)) {
            return
        }

        mainHandler.post {
            if (activeView != null && activeReason == cleanedReason) {
                return@post
            }

            dismiss(context)

            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val root =
                LinearLayout(context).apply {
                    orientation = LinearLayout.HORIZONTAL
                    gravity = Gravity.CENTER_VERTICAL
                    background = bannerBackground(context)
                    elevation = dp(context, 8).toFloat()
                    setPadding(dp(context, 10), dp(context, 7), dp(context, 12), dp(context, 7))
                }

            val mark = AnchorMarkView(context)
            val label =
                TextView(context).apply {
                    text = cleanedReason
                    setTextColor(0xFF1F2522.toInt())
                    textSize = 13f
                    setTypeface(Typeface.DEFAULT_BOLD)
                    maxLines = 1
                    ellipsize = TextUtils.TruncateAt.END
                    maxWidth = context.resources.displayMetrics.widthPixels - dp(context, 96)
                }

            root.addView(
                mark,
                LinearLayout.LayoutParams(dp(context, 22), dp(context, 22)),
            )
            root.addView(
                label,
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                ).apply {
                    marginStart = dp(context, 8)
                },
            )

            val params =
                WindowManager.LayoutParams(
                    WindowManager.LayoutParams.WRAP_CONTENT,
                    WindowManager.LayoutParams.WRAP_CONTENT,
                    overlayType(),
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                        WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
                    PixelFormat.TRANSLUCENT,
                ).apply {
                    gravity = Gravity.TOP or Gravity.CENTER_HORIZONTAL
                    y = statusBarHeight(context) + dp(context, 8)
                }

            try {
                windowManager.addView(root, params)
                activeView = root
                activeReason = cleanedReason
            } catch (_: RuntimeException) {
                activeView = null
                activeReason = null
            }
        }
    }

    fun dismiss(context: Context) {
        val view = activeView ?: return
        val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        activeView = null
        activeReason = null
        try {
            windowManager.removeViewImmediate(view)
        } catch (_: RuntimeException) {
            // The overlay may already have been removed by the system.
        }
    }

    private fun overlayType(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams.TYPE_PHONE
        }

    private fun bannerBackground(context: Context): GradientDrawable =
        GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = dp(context, 999).toFloat()
            setColor(0xF2FFFFFF.toInt())
            setStroke(dp(context, 1), 0xFFE0DAD1.toInt())
        }

    private fun statusBarHeight(context: Context): Int {
        val resourceId = context.resources.getIdentifier("status_bar_height", "dimen", "android")
        return if (resourceId > 0) context.resources.getDimensionPixelSize(resourceId) else 0
    }

    private fun dp(context: Context, value: Int): Int =
        (value * context.resources.displayMetrics.density).toInt()
}

private class AnchorMarkView(context: Context) : View(context) {
    private val ringPaint =
        Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeCap = Paint.Cap.ROUND
            strokeWidth = dp(1.7f)
            color = 0xAA5F766F.toInt()
        }

    private val dotPaint =
        Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.FILL
            color = 0xFFC94B42.toInt()
        }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val centerX = width / 2f
        val centerY = height / 2f
        val radius = minOf(width, height) * 0.32f
        canvas.drawCircle(centerX, centerY, radius, ringPaint)
        canvas.drawCircle(centerX, centerY, radius * 0.34f, dotPaint)
    }

    private fun dp(value: Float): Float = value * resources.displayMetrics.density
}
