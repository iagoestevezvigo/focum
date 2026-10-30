package com.focum.app.focum

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.text.TextUtils
import android.util.AttributeSet
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView

class ManualWheelView
    @JvmOverloads
    constructor(
        context: Context,
        attrs: AttributeSet? = null,
    ) : FrameLayout(context, attrs) {
        var onCategoryChosen: ((NativeIntentionCategory) -> Unit)? = null

        private val panel =
            LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.CENTER_HORIZONTAL
                background = panelBackground()
                setPadding(dp(16), dp(16), dp(16), dp(18))
            }

        private val headerChip =
            LinearLayout(context).apply {
                orientation = LinearLayout.HORIZONTAL
                gravity = Gravity.CENTER
                background = chipBackground()
                setPadding(dp(14), dp(10), dp(14), dp(10))
            }

        private val headerMark =
            FrameLayout(context).apply {
                background = markRing()
                layoutParams = LayoutParams(dp(16), dp(16))
            }

        private val headerDot =
            View(context).apply {
                background =
                    GradientDrawable().apply {
                        shape = GradientDrawable.OVAL
                        setColor(0xFFC94B42.toInt())
                    }
            }

        private val headerLabel =
            TextView(context).apply {
                text = context.getString(R.string.manual_mode)
                setTextColor(0xFF1D201E.toInt())
                textSize = 13.5f
                setTypeface(Typeface.DEFAULT_BOLD)
            }

        private val subtitleView =
            TextView(context).apply {
                text = context.getString(R.string.choose_main_reason)
                setTextColor(0xFF6B6F69.toInt())
                textSize = 13f
                gravity = Gravity.CENTER_HORIZONTAL
            }

        private val rowsContainer =
            LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.CENTER
            }

        private val itemViews = mutableListOf<ManualCategoryCardView>()
        private var categories: List<NativeIntentionCategory> = emptyList()
        private var selectedCategoryId: String? = null
        private var isConfirmingSelection = false

        init {
            clipChildren = false
            clipToPadding = false
            setPadding(0, dp(8), 0, dp(8))

            addView(
                panel,
                LayoutParams(
                    LayoutParams.MATCH_PARENT,
                    LayoutParams.WRAP_CONTENT,
                    Gravity.CENTER,
                ),
            )

            panel.addView(
                headerChip,
                LinearLayout.LayoutParams(
                    LayoutParams.WRAP_CONTENT,
                    LayoutParams.WRAP_CONTENT,
                ).apply {
                    gravity = Gravity.CENTER_HORIZONTAL
                },
            )
            headerChip.addView(
                headerMark,
                LayoutParams(dp(16), dp(16)),
            )
            headerMark.addView(
                headerDot,
                FrameLayout.LayoutParams(dp(6), dp(6), Gravity.CENTER),
            )
            headerChip.addView(
                headerLabel,
                LayoutParams(
                    LayoutParams.WRAP_CONTENT,
                    LayoutParams.WRAP_CONTENT,
                ).apply {
                    marginStart = dp(8)
                },
            )
            panel.addView(
                subtitleView,
                LinearLayout.LayoutParams(
                    LayoutParams.MATCH_PARENT,
                    LayoutParams.WRAP_CONTENT,
                ).apply {
                    topMargin = dp(14)
                },
            )
            panel.addView(
                rowsContainer,
                LinearLayout.LayoutParams(
                    LayoutParams.MATCH_PARENT,
                    LayoutParams.WRAP_CONTENT,
                ).apply {
                    topMargin = dp(16)
                },
            )
        }

        fun setCategories(value: List<NativeIntentionCategory>) {
            categories = value
            rebuildCategoryViews()
        }

        fun resetSelection() {
            isConfirmingSelection = false
            updateSelection(null)
        }

        private fun rebuildCategoryViews() {
            rowsContainer.removeAllViews()
            itemViews.clear()

            val categoryRows = buildCategoryRows(categories)
            for (rowIndex in categoryRows.indices) {
                val rowCategories = categoryRows[rowIndex]
                val row =
                    LinearLayout(context).apply {
                        orientation = LinearLayout.HORIZONTAL
                        gravity = Gravity.CENTER
                    }

                for (columnIndex in rowCategories.indices) {
                    val category = rowCategories[columnIndex]
                    val cardView = ManualCategoryCardView(context)
                    cardView.bind(category = category, selected = false)
                    cardView.setOnClickListener {
                        confirmSelection(category, cardView)
                    }
                    row.addView(
                        cardView,
                        LinearLayout.LayoutParams(
                            0,
                            LayoutParams.WRAP_CONTENT,
                            1f,
                        ).apply {
                            if (columnIndex > 0) {
                                marginStart = dp(12)
                            }
                        },
                    )
                    itemViews.add(cardView)
                }

                if (rowCategories.size == 1) {
                    row.addView(
                        View(context),
                        LinearLayout.LayoutParams(
                            0,
                            LayoutParams.WRAP_CONTENT,
                            1f,
                        ).apply {
                            marginStart = dp(12)
                        },
                    )
                }

                rowsContainer.addView(
                    row,
                    LinearLayout.LayoutParams(
                        LayoutParams.MATCH_PARENT,
                        LayoutParams.WRAP_CONTENT,
                    ).apply {
                        if (rowIndex > 0) {
                            topMargin = dp(10)
                        }
                    },
                )
            }

            updateSelection(selectedCategoryId)
        }

        private fun buildCategoryRows(
            items: List<NativeIntentionCategory>,
        ): List<List<NativeIntentionCategory>> {
            if (items.isEmpty()) {
                return emptyList()
            }

            val rows = mutableListOf<List<NativeIntentionCategory>>()
            var index = 0
            val preferredRowSizes =
                when (items.size) {
                    5 -> listOf(2, 3)
                    7 -> listOf(2, 3, 2)
                    else -> emptyList()
                }
            for (rowSize in preferredRowSizes) {
                rows.add(items.subList(index, index + rowSize))
                index += rowSize
            }

            while (index < items.size) {
                val remaining = items.size - index
                val rowSize =
                    when {
                        remaining == 3 -> 3
                        remaining < 3 -> remaining
                        else -> 2
                    }
                rows.add(items.subList(index, index + rowSize))
                index += rowSize
            }
            return rows
        }

        private fun confirmSelection(
            category: NativeIntentionCategory,
            cardView: ManualCategoryCardView,
        ) {
            if (isConfirmingSelection) {
                return
            }

            isConfirmingSelection = true
            updateSelection(category.id)
            subtitleView.text = category.emoji + " " + context.getString(category.labelRes)
            cardView.animate()
                .scaleX(0.99f)
                .scaleY(0.99f)
                .setDuration(70L)
                .withEndAction {
                    cardView.animate()
                        .scaleX(1.01f)
                        .scaleY(1.01f)
                        .setDuration(110L)
                        .start()
                }
                .start()

            postDelayed({
                onCategoryChosen?.invoke(category)
            }, 140L)
        }

        private fun updateSelection(categoryId: String?) {
            selectedCategoryId = categoryId
            if (categoryId == null) {
                subtitleView.text = context.getString(R.string.choose_main_reason)
            }

            for (itemView in itemViews) {
                itemView.bind(
                    category = itemView.category,
                    selected = itemView.category.id == categoryId,
                )
            }
        }

        private fun panelBackground(): GradientDrawable {
            return GradientDrawable(
                GradientDrawable.Orientation.TL_BR,
                intArrayOf(
                    0xFFFFFFFF.toInt(),
                    0xFFF8F6F0.toInt(),
                ),
            ).apply {
                shape = GradientDrawable.RECTANGLE
                cornerRadius = dp(24).toFloat()
                setStroke(dp(1), 0xFFE4DFD6.toInt())
            }
        }

        private fun chipBackground(): GradientDrawable {
            return GradientDrawable().apply {
                shape = GradientDrawable.RECTANGLE
                cornerRadius = dp(999).toFloat()
                setColor(0xFFFDFCFA.toInt())
                setStroke(dp(1), 0xFFD9D4CB.toInt())
            }
        }

        private fun markRing(): GradientDrawable {
            return GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.TRANSPARENT)
                setStroke(dp(1), 0x665F766F)
            }
        }

        private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()
    }

private class ManualCategoryCardView(
    context: Context,
) : LinearLayout(context) {
    private val emojiBubble =
        FrameLayout(context).apply {
            layoutParams = LayoutParams(dp(50), dp(50))
        }

    private val emojiText =
        TextView(context).apply {
            gravity = Gravity.CENTER
            textSize = 23f
        }

    private val labelText =
        TextView(context).apply {
            setTextColor(0xFF343531.toInt())
            textSize = 11.5f
            setTypeface(Typeface.DEFAULT_BOLD)
            gravity = Gravity.CENTER
            maxLines = 2
            ellipsize = TextUtils.TruncateAt.END
            includeFontPadding = false
        }

    private val selectionBadge =
        FrameLayout(context).apply {
            layoutParams = LayoutParams(dp(18), dp(18))
        }

    private val selectionDot = View(context)

    lateinit var category: NativeIntentionCategory
        private set

    init {
        orientation = VERTICAL
        gravity = Gravity.CENTER
        minimumHeight = dp(92)
        setPadding(dp(8), dp(10), dp(8), dp(10))
        isClickable = true
        isFocusable = true

        addView(
            emojiBubble,
            LayoutParams(
                dp(50),
                dp(50),
            ).apply {
                gravity = Gravity.CENTER_HORIZONTAL
            },
        )
        emojiBubble.addView(
            emojiText,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
                Gravity.CENTER,
            ),
        )
        addView(
            labelText,
            LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT,
            ).apply {
                topMargin = dp(8)
            },
        )
        addView(
            selectionBadge,
            LayoutParams(dp(18), dp(18)).apply {
                topMargin = dp(8)
                gravity = Gravity.CENTER_HORIZONTAL
            },
        )
        selectionBadge.addView(
            selectionDot,
            FrameLayout.LayoutParams(dp(6), dp(6), Gravity.CENTER),
        )
    }

    fun bind(category: NativeIntentionCategory, selected: Boolean) {
        this.category = category

        emojiText.text = category.emoji
        labelText.text = context.getString(category.labelRes)

        background = cardBackground(selected)
        emojiBubble.background = emojiBackground(selected)
        selectionBadge.background = badgeBackground(selected)
        selectionDot.background =
            GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(if (selected) 0xFFFFFFFF.toInt() else 0xFF5F766F.toInt())
            }

        labelText.setTextColor(if (selected) 0xFF1D201E.toInt() else 0xFF3F423D.toInt())
        selectionDot.alpha = if (selected) 1f else 0.0f
        scaleX = if (selected) 1.01f else 1f
        scaleY = if (selected) 1.01f else 1f
    }

    private fun cardBackground(selected: Boolean): GradientDrawable {
        return GradientDrawable(
            GradientDrawable.Orientation.TL_BR,
            intArrayOf(
                0xFFFFFFFF.toInt(),
                if (selected) 0xFFE8F0EC.toInt() else 0xFFFBFAF7.toInt(),
            ),
        ).apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = dp(18).toFloat()
            setStroke(
                dp(1),
                if (selected) 0xFF9CB0A7.toInt() else 0xFFE3DED5.toInt(),
            )
        }
    }

    private fun emojiBackground(selected: Boolean): GradientDrawable {
        return GradientDrawable(
            GradientDrawable.Orientation.TL_BR,
            intArrayOf(
                0xFFFFFFFF.toInt(),
                if (selected) 0xFFDDE8E3.toInt() else 0xFFF0ECE3.toInt(),
            ),
        ).apply {
            shape = GradientDrawable.OVAL
            setStroke(dp(1), if (selected) 0xFFB9C8C1.toInt() else 0xFFE2DDD4.toInt())
        }
    }

    private fun badgeBackground(selected: Boolean): GradientDrawable {
        return GradientDrawable().apply {
            shape = GradientDrawable.OVAL
            setColor(if (selected) 0xFF5F766F.toInt() else Color.TRANSPARENT)
            setStroke(
                dp(1),
                if (selected) 0xFF5F766F.toInt() else 0xFFD1CDC5.toInt(),
            )
        }
    }

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()
}
