import 'package:flutter/material.dart';

class LocationMarker extends StatelessWidget {
  const LocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.15),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}