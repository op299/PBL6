import 'package:flutter/material.dart';
import 'color_widgets.dart';

class DetectionOverlay extends StatelessWidget {
  final List<dynamic> detections;
  final Size originalImageSize;
  final Function(String label) onBoxTap;

  const DetectionOverlay({
    Key? key,
    required this.detections,
    required this.originalImageSize,
    required this.onBoxTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scaleX = constraints.maxWidth / originalImageSize.width;
        double scaleY = constraints.maxHeight / originalImageSize.height;

        return Stack(
          children: detections.map((det) {
            final box = det['bbox'] ;
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
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final String label = det['class_name'] ?? 'Unknown';
                  onBoxTap(label);
                },
                child: _buildBox(det), 
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBox(Map<String, dynamic> det) {
    final String labelEn = det['class_name'] ?? 'Unknown';
    final String labelVn = det['name_vn'] ?? det['object_name_vn'] ?? ''; 
    final double confidence = (det['confidence'] ?? 0.0).toDouble();
    
    final Color boxColor = getColorForLabel(labelEn);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: boxColor, width: 2.5),
        borderRadius: BorderRadius.circular(8),
        color: boxColor.withOpacity(0.05), 
      ),
      child: Stack(
        clipBehavior: Clip.none, 
        children: [
          Positioned(
            top: -25, 
            left: -2.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Text(
                "${labelEn.toUpperCase()} ${labelVn.isNotEmpty ? '($labelVn)' : ''} ${(confidence * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}