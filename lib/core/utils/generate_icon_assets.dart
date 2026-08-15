import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Generate assets', (tester) async {
    final directory = Directory('assets/branding');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 1024, 1024));

    // Canvas: Warm Cream (#FAF8F5)
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1024, 1024), Paint()..color = const Color(0xFFFAF8F5));

    // Centered 600x600 Scaled Viewport
    canvas.save();
    canvas.translate(212, 212);

    // 1. Organic Dusty Blush Watercolor Spot Wash
    final blushSpot = Paint()..color = const Color(0x33DCAE9F)..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(360, 260), width: 420, height: 420),
      blushSpot,
    );

    // 2. Organic Washed Sage Accent Wash
    final sageSpot = Paint()..color = const Color(0x338A9A86)..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(230, 380), width: 300, height: 300),
      sageSpot,
    );

    // 3. Charcoal Line Art Monogram Arch
    final strokePaint = Paint()
      ..color = const Color(0xFF1E242B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 46.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Floating Dot (Clarity Seed)
    canvas.drawCircle(const Offset(300, 100), 48.0, Paint()..color = const Color(0xFF1E242B));

    // Arch Stem
    final arch = Path();
    arch.moveTo(180, 520);
    arch.lineTo(180, 290);
    arch.cubicTo(180, 195, 420, 195, 420, 290);
    arch.lineTo(420, 520);
    canvas.drawPath(arch, strokePaint);

    canvas.restore();

    final picture = recorder.endRecording();
    final img = picture.toImageSync(1024, 1024);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    await File('assets/branding/ila_icon.png').writeAsBytes(pngBytes);
    await File('assets/branding/ila_splash.png').writeAsBytes(pngBytes);
    await File('assets/branding/ila_icon_foreground.png').writeAsBytes(pngBytes);

    print('Production icon assets created with Dusty Blush & Washed Sage palette.');
  });
}
