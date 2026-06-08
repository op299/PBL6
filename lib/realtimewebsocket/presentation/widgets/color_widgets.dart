import 'package:flutter/material.dart';


Color getColorForLabel(String label) {
  final List<Color> palette = [
    const Color(0xFFFF5252), // Đỏ san hô (Coral)
    const Color(0xFF448AFF), // Xanh Blue sáng
    const Color(0xFF00E676), // Xanh lá Mint
    const Color(0xFFFFD740), // Vàng Amber
    const Color(0xFFE040FB), // Tím Orchid
    const Color(0xFF00E5FF), // Xanh Aqua
    const Color(0xFFFF4081), // Hồng Rose
    const Color(0xFF7C4DFF), // Tím đậm
    const Color(0xFF66C457), // Xanh lá chủ đạo của App
    const Color(0xFFFFA726), // Cam Orange
    const Color(0xFF26C6DA), // Xanh ngọc
  ];
  final int hash = label.hashCode.abs();
  return palette[hash % palette.length];
}