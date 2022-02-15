import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class ImageEditor extends CustomPainter {
  ui.Image image;
  Size size;

  ImageEditor(this.image, this.size) : super();

  @override
  Future paint(Canvas canvas, Size size) async {
    if (image != null) {
      canvas.drawImage(image, Offset(size.width / 2 - image.width / 2, size.height / 2 - image.height / 2), Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return image != (oldDelegate as ImageEditor).image;
  }
}