import 'package:flutter/material.dart';
import 'package:focum/design_system/focum_colors.dart';

class FocumBackground extends StatelessWidget {
  const FocumBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [FocumColors.backgroundDark, Color(0xFF141917)]
              : const [FocumColors.background, Color(0xFFF3F0E8)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -100,
            child: _GlowOrb(
              size: 280,
              color: isDark
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : theme.colorScheme.primary.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -160,
            left: -110,
            child: _GlowOrb(
              size: 320,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.white.withValues(alpha: 0.46),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.42,
              spreadRadius: size * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
