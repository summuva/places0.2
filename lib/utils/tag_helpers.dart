import 'package:flutter/material.dart';
import '../models/tag_model.dart';

class TagHelpers {
  static String emojiForCategory(TagCategory category) {
    switch (category) {
      case TagCategory.bar:
        return '🍺';
      case TagCategory.afterOffice:
        return '🍸';
      case TagCategory.parque:
        return '🌳';
      case TagCategory.gastronomia:
        return '🍽️';
      case TagCategory.recital:
        return '🎵';
      case TagCategory.universidad:
        return '🎓';
      case TagCategory.coworking:
        return '💻';
    }
  }

  static IconData iconForCategory(TagCategory category) {
    switch (category) {
      case TagCategory.bar:
        return Icons.local_bar;
      case TagCategory.afterOffice:
        return Icons.work_off;
      case TagCategory.parque:
        return Icons.park;
      case TagCategory.gastronomia:
        return Icons.restaurant;
      case TagCategory.recital:
        return Icons.music_note;
      case TagCategory.universidad:
        return Icons.school;
      case TagCategory.coworking:
        return Icons.laptop;
    }
  }

  static String labelForCategory(TagCategory category) {
    switch (category) {
      case TagCategory.bar:
        return 'Bar';
      case TagCategory.afterOffice:
        return 'After Office';
      case TagCategory.parque:
        return 'Parque';
      case TagCategory.gastronomia:
        return 'Gastronomía';
      case TagCategory.recital:
        return 'Recital';
      case TagCategory.universidad:
        return 'Universidad';
      case TagCategory.coworking:
        return 'Coworking';
    }
  }

  /// Retorna el emoji principal del lugar basado en su primer tag
  /// Si tiene múltiples tags, muestra el primero
  /// Si no tiene tags, muestra 📍
  static String emojiForPlace(Set<Tag> tags) {
    if (tags.isEmpty) return '📍';
    return emojiForCategory(tags.first.category);
  }

  /// Retorna todos los emojis del lugar concatenados (máximo 3)
  static String emojisForPlace(Set<Tag> tags) {
    if (tags.isEmpty) return '📍';
    return tags
        .take(3)
        .map((t) => emojiForCategory(t.category))
        .join();
  }
}