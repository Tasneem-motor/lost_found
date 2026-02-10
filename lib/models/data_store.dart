import 'report.dart';

class DataStore {
  static List<Report> reports = [
    Report(reportId: "R001", type: "Lost", title: "Wallet"),
    Report(reportId: "R002", type: "Found", title: "ID Card"),
  ];
}
