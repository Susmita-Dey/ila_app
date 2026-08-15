import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class IlaLogo extends StatelessWidget {
  final double size;
  const IlaLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _IlaEditorialLogoPainter()),
    );
  }
}

class _IlaEditorialLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Organic Watercolor Spot Wash (Blush & Sage blend)
    final blushWash = Paint()..color = AppColors.blushTint..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.60, h * 0.44), width: w * 0.65, height: h * 0.65),
      blushWash,
    );

    final sageWash = Paint()..color = AppColors.sageTint..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.38, h * 0.62), width: w * 0.45, height: h * 0.45),
      sageWash,
    );

    // 2. Charcoal Line Art
    final inkPaint = Paint()
      ..color = AppColors.charcoalInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Floating Dot (Clarity Seed)
    canvas.drawCircle(Offset(w * 0.50, h * 0.18), w * 0.08, Paint()..color = AppColors.charcoalInk);

    // Architectural Arch Stem
    final arch = Path();
    arch.moveTo(w * 0.30, h * 0.86);
    arch.lineTo(w * 0.30, h * 0.48);
    arch.cubicTo(w * 0.30, h * 0.34, w * 0.70, h * 0.34, w * 0.70, h * 0.48);
    arch.lineTo(w * 0.70, h * 0.86);

    canvas.drawPath(arch, inkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
