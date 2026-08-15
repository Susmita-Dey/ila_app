import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class IllustrationSanctuary extends StatelessWidget {
  final double size;
  const IllustrationSanctuary({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SanctuaryPainter()),
    );
  }
}

class _SanctuaryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Organic Blush & Sage Background Wash
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.48, h * 0.45), width: w * 0.65, height: h * 0.65),
      Paint()..color = AppColors.blushTint..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.62, h * 0.68), width: w * 0.35, height: h * 0.35),
      Paint()..color = AppColors.sageTint..style = PaintingStyle.fill,
    );

    final ink = Paint()
      ..color = AppColors.charcoalInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    // Arch Frame
    final arch = Path();
    arch.moveTo(w * 0.22, h * 0.88);
    arch.lineTo(w * 0.22, h * 0.45);
    arch.cubicTo(w * 0.22, h * 0.15, w * 0.78, h * 0.15, w * 0.78, h * 0.45);
    arch.lineTo(w * 0.78, h * 0.88);
    canvas.drawPath(arch, ink);

    canvas.drawLine(Offset(w * 0.14, h * 0.88), Offset(w * 0.86, h * 0.88), ink);

    // Subtle Panes
    final paneInk = Paint()
      ..color = AppColors.charcoalInk.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(w * 0.50, h * 0.23), Offset(w * 0.50, h * 0.65), paneInk);
    canvas.drawLine(Offset(w * 0.26, h * 0.48), Offset(w * 0.74, h * 0.48), paneInk);

    // Plant Pot on Sill
    final pot = Path();
    pot.moveTo(w * 0.56, h * 0.88);
    pot.lineTo(w * 0.58, h * 0.76);
    pot.lineTo(w * 0.72, h * 0.76);
    pot.lineTo(w * 0.74, h * 0.88);
    pot.close();
    canvas.drawPath(pot, ink);

    // Sprouting Leaf
    final branch = Path();
    branch.moveTo(w * 0.65, h * 0.76);
    branch.cubicTo(w * 0.65, h * 0.65, w * 0.72, h * 0.58, w * 0.68, h * 0.48);
    canvas.drawPath(branch, ink);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.62, h * 0.62), width: 10, height: 6), Paint()..color = AppColors.washedSage);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.72, h * 0.54), width: 9, height: 5), Paint()..color = AppColors.washedSage);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
