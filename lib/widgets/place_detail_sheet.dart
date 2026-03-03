import 'dart:io';
import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../utils/tag_helpers.dart';

class PlaceDetailSheet extends StatelessWidget {
  final Place place;

  const PlaceDetailSheet({super.key, required this.place});

  static Future<void> show(BuildContext context, Place place) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PlaceDetailSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Foto + Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emoji + Nombre
                    Row(
                      children: [
                        Text(
                          TagHelpers.emojiForPlace(place.tags),
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            place.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Coordenadas
                    Text(
                      '📍 ${place.lat.toStringAsFixed(5)}, ${place.lng.toStringAsFixed(5)}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),

              // Foto
              if (place.photoPath != null) ...[
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(place.photoPath!),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Tags
          if (place.tags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: place.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        TagHelpers.emojiForCategory(tag.category),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        TagHelpers.labelForCategory(tag.category),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Botón cerrar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}