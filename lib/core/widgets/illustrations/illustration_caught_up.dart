import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class IllustrationCaughtUp extends StatelessWidget {
  final double size;

  const IllustrationCaughtUp({
    super.key,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CaughtUpPainter(),
      ),
    );
  }
}

class _CaughtUpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. The Floating Cycle Dot (Ila Rose)
    final dotPaint = Paint()
      ..color = AppColors.brandAction.withOpacity(0.15) // Soft background wash
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    
    // Draw a larger soft rose circle in the background
    canvas.drawCircle(Offset(w * 0.50, h * 0.50), w * 0.45, dotPaint);

    final solidDotPaint = Paint()
      ..color = AppColors.brandAction
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw a precise solid rose cycle dot
    canvas.drawCircle(Offset(w * 0.70, h * 0.30), w * 0.12, solidDotPaint);

    // 2. The Geometric Checkmark (Onyx)
    final checkPaint = Paint()
      ..color = AppColors.charcoalInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final checkPath = Path();
    checkPath.moveTo(w * 0.28, h * 0.52);
    checkPath.lineTo(w * 0.45, h * 0.68);
    checkPath.lineTo(w * 0.75, h * 0.38);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
