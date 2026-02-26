import 'tag_model.dart';

class Place {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final Set<Tag> tags;

  Place({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.tags,
  });
}