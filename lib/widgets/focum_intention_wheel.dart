import 'package:focum/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focum/design_system/focum_radius.dart';
import 'package:focum/design_system/focum_spacing.dart';
import 'package:focum/models/intention_category.dart';
import 'package:focum/widgets/focum_intention_item.dart';
import 'package:focum/widgets/focum_mark.dart';

class FocumIntentionWheel extends StatefulWidget {
  const FocumIntentionWheel({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelectionChanged,
    required this.onSelectionConfirmed,
    this.maxSize,
  });

  final List<IntentionCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onSelectionChanged;
  final ValueChanged<String> onSelectionConfirmed;
  final double? maxSize;

  @override
  State<FocumIntentionWheel> createState() => _FocumIntentionWheelState();
}

class _FocumIntentionWheelState extends State<FocumIntentionWheel> {
  bool _isConfirming = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selectedCategory = _selectedCategory;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.maxSize == null
            ? constraints.maxWidth
            : widget.maxSize!.clamp(0.0, constraints.maxWidth).toDouble();
        final cardWidth = (width - FocumSpacing.sm) / 2;

        return Container(
          width: width,
          padding: const EdgeInsets.all(FocumSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scheme.surface.withValues(alpha: 0.94),
                scheme.surface.withValues(alpha: 0.82),
              ],
            ),
            borderRadius: BorderRadius.circular(FocumRadius.xLarge),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FocumMark(size: 18, color: scheme.primary),
                  const SizedBox(width: FocumSpacing.xs),
                  Text(
                    context.l10n.manualMode,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FocumSpacing.sm),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  selectedCategory == null
                      ? context.l10n.chooseMainReason
                      : '${selectedCategory.emoji} ${selectedCategory.localizedLabel(context.l10n)}',
                  key: ValueKey(selectedCategory?.id),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: FocumSpacing.lg),
              Wrap(
                spacing: FocumSpacing.sm,
                runSpacing: FocumSpacing.sm,
                children: [
                  for (final category in widget.categories)
                    SizedBox(
                      width: cardWidth,
                      child: FocumIntentionItem(
                        category: category,
                        selected: widget.selectedCategoryId == category.id,
                        enabled: !_isConfirming,
                        onTap: () => _confirmSelection(category.id),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  IntentionCategory? get _selectedCategory {
    final selectedId = widget.selectedCategoryId;
    if (selectedId == null) {
      return null;
    }

    for (final category in widget.categories) {
      if (category.id == selectedId) {
        return category;
      }
    }
    return null;
  }

  Future<void> _confirmSelection(String categoryId) async {
    if (_isConfirming) {
      return;
    }

    setState(() {
      _isConfirming = true;
    });
    widget.onSelectionChanged(categoryId);
    HapticFeedback.selectionClick();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    HapticFeedback.lightImpact();
    widget.onSelectionConfirmed(categoryId);
    if (!mounted) {
      return;
    }
    setState(() {
      _isConfirming = false;
    });
  }
}
