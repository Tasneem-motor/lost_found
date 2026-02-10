class FoundItem {
  String reportId;
  String location;
  DateTime dateTime;
  bool receivedByDept;
  bool claimed;

  FoundItem({
    required this.reportId,
    required this.location,
    required this.dateTime,
    this.receivedByDept = false,
    this.claimed = false,
  });
}
