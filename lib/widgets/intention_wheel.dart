import 'package:focum/l10n/l10n.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focum/models/intention_category.dart';
import 'package:focum/widgets/intention_category_button.dart';

class IntentionWheel extends StatefulWidget {
  const IntentionWheel({
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
  State<IntentionWheel> createState() => _IntentionWheelState();
}

class _IntentionWheelState extends State<IntentionWheel> {
  String? _dragSelectionId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableSize = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final size = math.min(widget.maxSize ?? 320, availableSize);
        final radius = size * 0.34;

        return SizedBox(
          width: size,
          height: size,
          child: GestureDetector(
            onPanDown: (details) =>
                _updateSelection(details.localPosition, size),
            onPanUpdate: (details) =>
                _updateSelection(details.localPosition, size),
            onPanEnd: (_) => _confirmDragSelection(),
            onPanCancel: _clearDragSelection,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Container(
                    width: size * 0.7,
                    height: size * 0.7,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F2),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: const Color(0xFFD5D5CE)),
                    ),
                  ),
                ),
                for (var i = 0; i < widget.categories.length; i++)
                  _buildCategoryNode(
                    size: size,
                    radius: radius,
                    category: widget.categories[i],
                    index: i,
                  ),
                Center(
                  child: _WheelCenter(
                    selectedCategoryId: widget.selectedCategoryId,
                    categories: widget.categories,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryNode({
    required double size,
    required double radius,
    required IntentionCategory category,
    required int index,
  }) {
    final angle =
        (-math.pi / 2) + (2 * math.pi * index / widget.categories.length);
    final center = size / 2;
    final itemCenterX = center + (radius * math.cos(angle));
    final itemCenterY = center + (radius * math.sin(angle));

    return Positioned(
      left: itemCenterX - 36,
      top: itemCenterY - 36,
      child: IntentionCategoryButton(
        category: category,
        selected: widget.selectedCategoryId == category.id,
        onTap: () {
          widget.onSelectionChanged(category.id);
          widget.onSelectionConfirmed(category.id);
        },
      ),
    );
  }

  void _updateSelection(Offset position, double size) {
    final center = Offset(size / 2, size / 2);
    final delta = position - center;
    final distance = delta.distance;

    if (distance < size * 0.18 || distance > size * 0.52) {
      return;
    }

    final segment = 2 * math.pi / widget.categories.length;
    final normalizedAngle =
        (math.atan2(delta.dy, delta.dx) + math.pi / 2 + 2 * math.pi) %
        (2 * math.pi);
    final index =
        ((normalizedAngle + segment / 2) / segment).floor() %
        widget.categories.length;
    final selectionId = widget.categories[index].id;

    _dragSelectionId = selectionId;
    widget.onSelectionChanged(selectionId);
  }

  void _confirmDragSelection() {
    final selectionId = _dragSelectionId;
    if (selectionId != null) {
      widget.onSelectionConfirmed(selectionId);
    }
    _dragSelectionId = null;
  }

  void _clearDragSelection() {
    _dragSelectionId = null;
  }
}

class _WheelCenter extends StatelessWidget {
  const _WheelCenter({
    required this.selectedCategoryId,
    required this.categories,
  });

  final String? selectedCategoryId;
  final List<IntentionCategory> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IntentionCategory? selected;
    for (final category in categories) {
      if (category.id == selectedCategoryId) {
        selected = category;
        break;
      }
    }

    return Container(
      width: 168,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFD5D5CE)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected?.localizedLabel(context.l10n) ?? context.l10n.tapAnIcon,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF42423E),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              selected == null
                  ? context.l10n.orUseMicrophone
                  : context.l10n.savedInstantly,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF7A7A74),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
