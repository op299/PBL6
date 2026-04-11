import 'package:flutter/material.dart';
import 'color_widgets.dart';

class DetectionOverlay extends StatelessWidget {
  final List<dynamic> detections;
  final Size originalImageSize;

  const DetectionOverlay({
    Key? key,
    required this.detections,
    required this.originalImageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scaleX = constraints.maxWidth / originalImageSize.width;
        double scaleY = constraints.maxHeight / originalImageSize.height;

        return Stack(
          children: detections.map((det) {
            final box = det['bbox'];
            if (box == null) return const SizedBox.shrink();
            double left = box[0] * scaleX;
            double top = box[1] * scaleY;
            double width = (box[2] - box[0]) * scaleX;
            double height = (box[3] - box[1]) * scaleY;

            return Positioned(
              left: left,
              top: top,
              width: width,
              height: height,
              child: _buildBox(det['label'] ?? '', det['confidence'] ?? 0.0),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBox(String label, double confidence) {
    final Color boxColor = getColorForLabel(label);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: boxColor, width: 2)),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          color: boxColor,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            "${label.toUpperCase()} ${(confidence * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
