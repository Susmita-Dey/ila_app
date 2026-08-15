import 'package:flutter/material.dart';

enum IlaLogoStyle { cairn, arch }

class IlaLogo extends StatelessWidget {
  final double size;
  final IlaLogoStyle style;
  final Color? inkColor;
  final Color? sageColor;

  const IlaLogo({
    super.key,
    this.size = 32,
    this.style = IlaLogoStyle.cairn,
    this.inkColor,
    this.sageColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: style == IlaLogoStyle.cairn
            ? _IlaCairnPainter(
                inkColor: inkColor ?? const Color(0xFF1E242B),
                sageColor: sageColor ?? const Color(0xFF7A8B7B),
              )
            : _IlaArchPainter(
                inkColor: inkColor ?? const Color(0xFF1E242B),
                sageColor: sageColor ?? const Color(0xFF7A8B7B),
              ),
      ),
    );
  }
}

/// Solid Minimalist Cairn (Balanced Organic River Stones)
class _IlaCairnPainter extends CustomPainter {
  final Color inkColor;
  final Color sageColor;

  _IlaCairnPainter({required this.inkColor, required this.sageColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base Grounding Stone (Deep Ink)
    final basePaint = Paint()
      ..color = inkColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final baseStone = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromCenter(center: Offset(w * 0.50, h * 0.68), width: w * 0.72, height: h * 0.38),
        topLeft: Radius.circular(w * 0.20),
        topRight: Radius.circular(w * 0.20),
        bottomLeft: Radius.circular(w * 0.18),
        bottomRight: Radius.circular(w * 0.18),
      ));
    canvas.drawPath(baseStone, basePaint);

    // Resting Balance Stone (Muted Sage)
    final topPaint = Paint()
      ..color = sageColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final topStone = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromCenter(center: Offset(w * 0.44, h * 0.36), width: w * 0.48, height: h * 0.30),
        topLeft: Radius.circular(w * 0.16),
        topRight: Radius.circular(w * 0.16),
        bottomLeft: Radius.circular(w * 0.14),
        bottomRight: Radius.circular(w * 0.14),
      ));
    canvas.drawPath(topStone, topPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The Sanctuary Arch ('i' Monogram)
class _IlaArchPainter extends CustomPainter {
  final Color inkColor;
  final Color sageColor;

  _IlaArchPainter({required this.inkColor, required this.sageColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Floating Dot / Seed (Muted Sage)
    final dotPaint = Paint()
      ..color = sageColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(w * 0.5, h * 0.20), w * 0.09, dotPaint);

    // Arch Body / Pillar (Deep Ink)
    final archPaint = Paint()
      ..color = inkColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final archPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(w * 0.36, h * 0.38, w * 0.28, h * 0.48),
        topLeft: Radius.circular(w * 0.14),
        topRight: Radius.circular(w * 0.14),
        bottomLeft: Radius.circular(w * 0.06),
        bottomRight: Radius.circular(w * 0.06),
      ));
    canvas.drawPath(archPath, archPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
