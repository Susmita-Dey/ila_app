import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class IllustrationReport extends StatelessWidget {
  final double size;
  const IllustrationReport({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.85,
      child: CustomPaint(painter: _ReportPainter()),
    );
  }
}

class _ReportPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Terracotta & Blush Wash
    canvas.drawCircle(
      Offset(w * 0.55, h * 0.48),
      w * 0.32,
      Paint()..color = AppColors.clayTint..style = PaintingStyle.fill,
    );

    final ink = Paint()
      ..color = AppColors.charcoalInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Document Folder
    final folder = Path();
    folder.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.48, h * 0.50), width: w * 0.52, height: h * 0.68),
      const Radius.circular(8),
    ));
    canvas.drawPath(folder, ink);

    // Top Clip
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.48, h * 0.16), width: w * 0.22, height: h * 0.08),
        const Radius.circular(3),
      ),
      ink,
    );

    // Structured Lines
    canvas.drawLine(Offset(w * 0.30, h * 0.34), Offset(w * 0.58, h * 0.34), ink);
    canvas.drawLine(Offset(w * 0.30, h * 0.46), Offset(w * 0.66, h * 0.46), ink);
    canvas.drawLine(Offset(w * 0.30, h * 0.58), Offset(w * 0.50, h * 0.58), ink);

    // Verification Seal (Sage)
    canvas.drawCircle(Offset(w * 0.65, h * 0.70), 8, Paint()..color = AppColors.washedSage);
    final check = Path()
      ..moveTo(w * 0.62, h * 0.70)
      ..lineTo(w * 0.64, h * 0.73)
      ..lineTo(w * 0.68, h * 0.67);
    canvas.drawPath(check, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.8..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
