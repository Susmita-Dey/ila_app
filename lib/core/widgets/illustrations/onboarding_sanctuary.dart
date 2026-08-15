import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OnboardingSanctuaryIllustration extends StatelessWidget {
  final double size;
  const OnboardingSanctuaryIllustration({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SanctuaryPainter(),
      ),
    );
  }
}

class _SanctuaryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = AppColors.deepInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final sageStroke = Paint()
      ..color = AppColors.mutedSage
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Sanctuary Arch
    final arch = Path();
    arch.moveTo(w * 0.2, h * 0.85);
    arch.lineTo(w * 0.2, h * 0.45);
    arch.arcToPoint(
      Offset(w * 0.8, h * 0.45),
      radius: Radius.circular(w * 0.3),
      clockwise: true,
    );
    arch.lineTo(w * 0.8, h * 0.85);
    canvas.drawPath(arch, stroke);

    // Inner horizon line
    canvas.drawLine(Offset(w * 0.15, h * 0.85), Offset(w * 0.85, h * 0.85), stroke);

    // Botanical stem inside arch
    final stem = Path();
    stem.moveTo(w * 0.5, h * 0.85);
    stem.cubicTo(w * 0.5, h * 0.65, w * 0.65, h * 0.55, w * 0.5, h * 0.35);
    canvas.drawPath(stem, sageStroke);

    // Leaves
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.57, h * 0.60), width: 14, height: 8), sageStroke);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.44, h * 0.48), width: 12, height: 7), sageStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
