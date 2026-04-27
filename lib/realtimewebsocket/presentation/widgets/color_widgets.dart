import 'package:flutter/material.dart';

Color getColorForLabel(String label) {
  final List<Color> palette = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
  ];
  final int hash = label.hashCode.abs();
  return palette[hash % palette.length];
}
