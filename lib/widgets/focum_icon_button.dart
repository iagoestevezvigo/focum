import 'package:flutter/material.dart';

class FocumIconButton extends StatelessWidget {
  const FocumIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.emphasized = false,
    this.size = 64,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool emphasized;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg =
        backgroundColor ??
        (emphasized ? scheme.primary : scheme.surface.withValues(alpha: 0.74));
    final fg =
        foregroundColor ?? (emphasized ? scheme.onPrimary : scheme.onSurface);
    final border =
        borderColor ??
        (emphasized
            ? Colors.transparent
            : scheme.outline.withValues(alpha: 0.95));

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: bg,
        shape: CircleBorder(side: BorderSide(color: border)),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(icon, size: size * 0.34, color: fg),
        ),
      ),
    );
  }
}
