import 'package:focum/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:focum/models/intention_category.dart';

class IntentionCategoryButton extends StatelessWidget {
  const IntentionCategoryButton({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final IntentionCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: category.localizedLabel(context.l10n),
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: selected ? 1.02 : 1,
          child: SizedBox(
            width: 72,
            height: 72,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEDEDE7)
                    : const Color(0xFFF6F6F2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFC1C1BA)
                      : const Color(0xFFD8D8D1),
                ),
              ),
              child: Center(
                child: Text(
                  category.emoji,
                  style: TextStyle(fontSize: selected ? 29 : 28),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
