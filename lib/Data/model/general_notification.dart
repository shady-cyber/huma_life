//model of cash notification request
class GeneralNotify {
  final int RequestID;
  final String RequestDate;
  final String RequestTitle;
  final String RequestDetails;
  final String EmpNameE;
  final String EmpNameA;
  final String FK_EmpCode;
  final String IsNotify;
  final String IsApprove;
  final String IsDecision;
  final String StatusA;
  final String StatusE;

  const GeneralNotify({
    required this.RequestID,
    required this.RequestDate,
    required this.RequestTitle,
    required this.RequestDetails,
    required this.EmpNameE,
    required this.EmpNameA,
    required this.FK_EmpCode,
    required this.IsNotify,
    required this.IsApprove,
    required this.IsDecision,
    required this.StatusA,
    required this.StatusE,
  });

  factory GeneralNotify.fromJson(Map<String, dynamic> json) {
    return GeneralNotify(
      RequestID: json['RequestID'] ?? 0,
      RequestDate: json['RequestDate'] ?? '',
      RequestTitle: json['RequestTitle'] ?? '',
      RequestDetails: json['RequestDetails'] ?? '',
      EmpNameE: json['EmpNameE'] ?? '',
      EmpNameA: json['EmpNameA'] ?? '',
      FK_EmpCode: json['FK_EmpCode'] ?? '',
      IsNotify: json['IsNotify'] ?? '',
      IsApprove: json['IsApprove'] ?? '',
      IsDecision: json['IsDecision'] ?? '',
      StatusA: json['StatusA'] ?? '',
      StatusE: json['StatusE'] ?? '',
    );
  }
}
