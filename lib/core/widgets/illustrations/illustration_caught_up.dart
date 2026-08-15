import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class IllustrationCaughtUp extends StatelessWidget {
  final double size;
  const IllustrationCaughtUp({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.85,
      child: CustomPaint(painter: _CaughtUpPainter()),
    );
  }
}

class _CaughtUpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft Blush & Ochre Watercolor Wash
    final wash = Paint()..color = AppColors.blushTint..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.48, h * 0.52), width: w * 0.55, height: w * 0.45),
      wash,
    );

    final ink = Paint()
      ..color = AppColors.charcoalInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final sageInk = Paint()
      ..color = AppColors.washedSage
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // Baseline Desk
    canvas.drawLine(Offset(w * 0.15, h * 0.85), Offset(w * 0.85, h * 0.85), ink);

    // Teacup Silhouette
    final cup = Path();
    cup.moveTo(w * 0.35, h * 0.55);
    cup.lineTo(w * 0.38, h * 0.80);
    cup.cubicTo(w * 0.40, h * 0.85, w * 0.60, h * 0.85, w * 0.62, h * 0.80);
    cup.lineTo(w * 0.65, h * 0.55);
    cup.close();
    canvas.drawPath(cup, ink);

    // Saucer
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.50, h * 0.84), width: w * 0.40, height: h * 0.08), ink);

    // Steam Lines
    final steam = Path();
    steam.moveTo(w * 0.46, h * 0.46);
    steam.cubicTo(w * 0.44, h * 0.38, w * 0.48, h * 0.32, w * 0.46, h * 0.24);
    steam.moveTo(w * 0.54, h * 0.44);
    steam.cubicTo(w * 0.52, h * 0.36, w * 0.56, h * 0.30, w * 0.54, h * 0.22);
    canvas.drawPath(steam, ink);

    // Eucalyptus Branch
    final branch = Path();
    branch.moveTo(w * 0.62, h * 0.82);
    branch.cubicTo(w * 0.72, h * 0.70, w * 0.78, h * 0.58, w * 0.82, h * 0.42);
    canvas.drawPath(branch, sageInk);

    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.70, h * 0.72), width: 14, height: 9), sageInk);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.76, h * 0.60), width: 13, height: 8), sageInk);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.81, h * 0.48), width: 10, height: 7), sageInk);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
