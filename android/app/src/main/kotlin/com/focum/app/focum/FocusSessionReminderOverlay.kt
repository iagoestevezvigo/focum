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
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView

object FocusSessionReminderOverlay {
    private const val AUTO_DISMISS_MILLIS = 12_000L
    private val mainHandler = Handler(Looper.getMainLooper())
    private var activeView: View? = null

    fun show(context: Context, message: String) {
        val cleanedMessage = message.trim()
        if (cleanedMessage.isEmpty()) {
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(context)) {
            return
        }

        mainHandler.post {
            dismiss(context)

            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val root =
                FrameLayout(context).apply {
                    setBackgroundColor(0x66000000)
                    isClickable = false
                    isFocusable = false
                }

            val panel =
                LinearLayout(context).apply {
                    orientation = LinearLayout.VERTICAL
                    gravity = Gravity.CENTER_HORIZONTAL
                    background = panelBackground(context)
                    elevation = dp(context, 10).toFloat()
                    setPadding(dp(context, 22), dp(context, 22), dp(context, 22), dp(context, 20))
                }

            val mark = ReminderMarkView(context)
            val title =
                TextView(context).apply {
                    text = context.getString(R.string.five_minutes_title)
                    setTextColor(0xFF1D201E.toInt())
                    textSize = 22f
                    gravity = Gravity.CENTER
                    setTypeface(Typeface.DEFAULT_BOLD)
                }
            val body =
                TextView(context).apply {
                    text = cleanedMessage
                    setTextColor(0xFF565B55.toInt())
                    textSize = 15f
                    gravity = Gravity.CENTER
                    setLineSpacing(dp(context, 2).toFloat(), 1.0f)
                }
            val action =
                TextView(context).apply {
                    text = context.getString(R.string.keep_going)
                    setTextColor(0xFFFFFFFF.toInt())
                    textSize = 14f
                    gravity = Gravity.CENTER
                    setTypeface(Typeface.DEFAULT_BOLD)
                    background = actionBackground(context)
                    setPadding(dp(context, 18), dp(context, 12), dp(context, 18), dp(context, 12))
                    setOnClickListener { dismiss(context) }
                }

            panel.addView(mark, LinearLayout.LayoutParams(dp(context, 42), dp(context, 42)))
            panel.addView(
                title,
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                ).apply {
                    topMargin = dp(context, 12)
                },
            )
            panel.addView(
                body,
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                ).apply {
                    topMargin = dp(context, 12)
                },
            )
            panel.addView(
                action,
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                ).apply {
                    topMargin = dp(context, 20)
                },
            )

            root.addView(
                panel,
                FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.WRAP_CONTENT,
                    Gravity.CENTER,
                ).apply {
                    marginStart = dp(context, 30)
                    marginEnd = dp(context, 30)
                },
            )

            val params =
                WindowManager.LayoutParams(
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT,
                    overlayType(),
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS or
                        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                    PixelFormat.TRANSLUCENT,
                ).apply {
                    gravity = Gravity.TOP or Gravity.START
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        layoutInDisplayCutoutMode =
                            WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
                    }
                }

            try {
                windowManager.addView(root, params)
                activeView = root
                mainHandler.postDelayed({ dismiss(context) }, AUTO_DISMISS_MILLIS)
            } catch (_: RuntimeException) {
                activeView = null
            }
        }
    }

    fun dismiss(context: Context) {
        val view = activeView ?: return
        val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        activeView = null
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

    private fun panelBackground(context: Context): GradientDrawable =
        GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = dp(context, 26).toFloat()
            setColor(0xFFFFFFFF.toInt())
            setStroke(dp(context, 1), 0xFFD9D4CB.toInt())
        }

    private fun actionBackground(context: Context): GradientDrawable =
        GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = dp(context, 999).toFloat()
            setColor(0xFF4E625A.toInt())
        }

    private fun dp(context: Context, value: Int): Int =
        (value * context.resources.displayMetrics.density).toInt()
}

private class ReminderMarkView(context: Context) : View(context) {
    private val ringPaint =
        Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeCap = Paint.Cap.ROUND
            strokeWidth = dp(2.1f)
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
        val radius = minOf(width, height) * 0.34f
        canvas.drawCircle(centerX, centerY, radius, ringPaint)
        canvas.drawCircle(centerX, centerY, radius * 0.32f, dotPaint)
    }

    private fun dp(value: Float): Float = value * resources.displayMetrics.density
}
