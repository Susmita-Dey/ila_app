import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class IllustrationSanctuary extends StatelessWidget {
  final double size;

  const IllustrationSanctuary({
    super.key,
    this.size = 200,
  });

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
    final w = size.width;
    final h = size.height;

    // 1. Soft glowing background (Ila Rose at very low opacity)
    final glowPaint = Paint()
      ..color = AppColors.brandAction.withOpacity(0.08)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.45, glowPaint);

    // 2. The Solid Rose Sun/Moon (Ila Rose)
    final sunPaint = Paint()
      ..color = AppColors.brandAction
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(w * 0.65, h * 0.35), w * 0.15, sunPaint);

    // 3. Minimalist Botanical Geometry (Onyx)
    final linePaint = Paint()
      ..color = AppColors.charcoalInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final path = Path();
    // Central sweeping stem
    path.moveTo(w * 0.35, h * 0.90);
    path.quadraticBezierTo(w * 0.5, h * 0.6, w * 0.4, h * 0.2);

    // Left Geometric Leaf
    path.moveTo(w * 0.45, h * 0.65);
    path.quadraticBezierTo(w * 0.25, h * 0.55, w * 0.20, h * 0.45);
    path.quadraticBezierTo(w * 0.35, h * 0.45, w * 0.41, h * 0.55);

    // Right Geometric Leaf
    path.moveTo(w * 0.43, h * 0.45);
    path.quadraticBezierTo(w * 0.65, h * 0.35, w * 0.70, h * 0.20);
    path.quadraticBezierTo(w * 0.55, h * 0.25, w * 0.42, h * 0.35);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
