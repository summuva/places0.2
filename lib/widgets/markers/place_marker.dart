import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../utils/tag_helpers.dart';

class PlaceMarker extends StatelessWidget {
  final Place place;

  const PlaceMarker({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final emoji = TagHelpers.emojiForPlace(place.tags);

    return Tooltip(
      message: place.name,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                if (place.tags.length > 1)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: _TagBadge(count: place.tags.length),
                  ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(12, 6),
            painter: _ArrowPainter(),
          ),
        ],
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final int count;
  const _TagBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = Colors.black.withOpacity(0.15)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}