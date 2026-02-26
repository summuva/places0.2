class Tag {
  final String id;
  final String name;
  final TagCategory category;

  const Tag({
    required this.id,
    required this.name,
    required this.category,
  });
}
 
enum TagCategory {
  bar,
  afterOffice,
  parque,
  gastronomia,
  recital,
  universidad,
  coworking
}