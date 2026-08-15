import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = Directory('assets/branding');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  // 1. Generate 1024x1024 App Icon (Warm Ivory canvas + Solid Cairn)
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 1024, 1024));

  // Background Fill: Warm Ivory (#FBF9F5)
  final bgPaint = Paint()..color = const Color(0xFFFBF9F5);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 1024, 1024), bgPaint);

  // Scaled High-Resolution Cairn Vector Mark
  canvas.save();
  canvas.translate(262, 262); // Centered 500x500 viewport

  // Base Stone: Deep Ink (#1E242B)
  final baseStone = Path()
    ..addRRect(RRect.fromRectAndCorners(
      Rect.fromCenter(center: const Offset(250, 340), width: 360, height: 190),
      topLeft: const Radius.circular(100),
      topRight: const Radius.circular(100),
      bottomLeft: const Radius.circular(90),
      bottomRight: const Radius.circular(90),
    ));
  canvas.drawPath(baseStone, Paint()..color = const Color(0xFF1E242B)..isAntiAlias = true);

  // Top Stone: Muted Sage (#7A8B7B)
  final topStone = Path()
    ..addRRect(RRect.fromRectAndCorners(
      Rect.fromCenter(center: const Offset(220, 180), width: 240, height: 150),
      topLeft: const Radius.circular(80),
      topRight: const Radius.circular(80),
      bottomLeft: const Radius.circular(70),
      bottomRight: const Radius.circular(70),
    ));
  canvas.drawPath(topStone, Paint()..color = const Color(0xFF7A8B7B)..isAntiAlias = true);
  canvas.restore();

  final picture = recorder.endRecording();
  final img = await picture.toImage(1024, 1024);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  // Write Master PNGs
  await File('assets/branding/ila_icon.png').writeAsBytes(pngBytes);
  await File('assets/branding/ila_splash.png').writeAsBytes(pngBytes);
  await File('assets/branding/ila_icon_foreground.png').writeAsBytes(pngBytes);

  print('Production icon assets created successfully at assets/branding/');
  exit(0);
}
