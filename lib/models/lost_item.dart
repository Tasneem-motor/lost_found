class LostItem {
  String id;
  String title;
  String description;
  String location;
  DateTime dateLost;
  bool claimed; // ✅ NOT nullable

  LostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dateLost,
    this.claimed = false, // ✅ default value
  });
}
