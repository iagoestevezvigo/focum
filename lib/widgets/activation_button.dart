import 'package:focum/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ActivationButton extends StatelessWidget {
  const ActivationButton({
    super.key,
    required this.active,
    required this.enabled,
    required this.onPressed,
  });

  final bool active;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled || active ? onPressed : null,
      child: Text(
        active ? context.l10n.deactivateFocum : context.l10n.activateFocum,
      ),
    );
  }
}
