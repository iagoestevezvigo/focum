import 'dart:math' as math;

import 'package:flutter/material.dart';

class VoiceWaveform extends StatefulWidget {
  const VoiceWaveform({super.key, required this.active, this.height = 56});

  final bool active;
  final double height;

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant VoiceWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) {
      _syncAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncAnimation() {
    if (widget.active) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
      return;
    }

    _controller.stop();
    _controller.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          height: widget.height,
          width: double.infinity,
          child: CustomPaint(
            painter: _VoiceWaveformPainter(
              progress: _controller.value,
              active: widget.active,
              activeColor: Theme.of(context).colorScheme.primary,
              idleColor: Theme.of(context).dividerColor,
            ),
          ),
        );
      },
    );
  }
}

class _VoiceWaveformPainter extends CustomPainter {
  const _VoiceWaveformPainter({
    required this.progress,
    required this.active,
    required this.activeColor,
    required this.idleColor,
  });

  final double progress;
  final bool active;
  final Color activeColor;
  final Color idleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..color = activeColor.withValues(alpha: active ? 0.92 : 0.42);

    final idlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = idleColor.withValues(alpha: 0.55);

    final centerY = size.height / 2;
    canvas.drawLine(
      Offset.zero.translate(0, centerY),
      Offset(size.width, centerY),
      idlePaint,
    );

    final path = Path();
    final amplitude = active ? size.height * 0.22 : size.height * 0.035;

    for (double x = 0; x <= size.width; x += 4) {
      final normalizedX = x / size.width;
      final waveA = math.sin(
        (normalizedX * 3.2 * math.pi) + (progress * math.pi * 2),
      );
      final waveB = math.sin(
        (normalizedX * 8.0 * math.pi) - (progress * math.pi * 4),
      );
      final y = centerY + ((waveA * 0.7) + (waveB * 0.3)) * amplitude;

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _VoiceWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.active != active;
  }
}
