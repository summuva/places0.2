import 'package:places2/models/tag_model.dart';



class Event {
  final String id;
  final String title;
  final DateTime date;
  final Set<Tag> tags;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.tags,
  });
}