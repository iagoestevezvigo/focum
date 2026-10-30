import 'package:flutter/material.dart';

class VoiceInputButton extends StatelessWidget {
  const VoiceInputButton({
    super.key,
    required this.listening,
    required this.active,
    required this.onPressed,
  });

  final bool listening;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? const Color(0xFFE3E3DD) : const Color(0xFFF8F8F5),
          border: Border.all(
            color: active ? const Color(0xFFC5C5BF) : const Color(0xFFD7D7D1),
          ),
        ),
        child: Icon(
          listening ? Icons.graphic_eq_rounded : Icons.mic_none_rounded,
          color: const Color(0xFF4A4A45),
          size: 28,
        ),
      ),
    );
  }
}
