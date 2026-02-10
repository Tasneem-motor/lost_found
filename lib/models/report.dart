class Report {
  String reportId;
  String type; // Lost / Found
  String title;
  bool received;
  bool claimed;
  String? ownerSapId;

  Report({
    required this.reportId,
    required this.type,
    required this.title,
    this.received = false,
    this.claimed = false,
    this.ownerSapId,
  });
}
