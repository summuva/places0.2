import 'package:flutter/material.dart';

class SelectionMarker extends StatelessWidget {
  const SelectionMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.location_on,
      color: Colors.black,
      size: 50,
    );
  }
}