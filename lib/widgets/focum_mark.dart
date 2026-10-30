import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_colors.dart';

class FocumMark extends StatelessWidget {
  const FocumMark({super.key, this.size = 24, this.color, this.dotColor});

  final double size;
  final Color? color;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    final resolvedDotColor = dotColor ?? FocumColors.signalRed;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: resolvedColor.withValues(alpha: 0.34),
                width: size * 0.075,
              ),
            ),
          ),
          Container(
            width: size * 0.34,
            height: size * 0.34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: resolvedDotColor,
            ),
          ),
        ],
      ),
    );
  }
}
