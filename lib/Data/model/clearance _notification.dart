//model of clearance notification request
class ClearanceNotify {
  final String EmpClearanceRequestID;
  final String RequestDate;
  final String FK_EmpCode;
  final String RequestDetails;
  final String EmpNameE;
  final String EmpNameA;
  final String EmpType;
  final String IsNotify;
  final String IsApprove;
  final String IsDecision;
  final String StatusA;
  final String StatusE;

  const ClearanceNotify({
    required this.EmpClearanceRequestID,
    required this.RequestDate,
    required this.FK_EmpCode,
    required this.RequestDetails,
    required this.EmpNameE,
    required this.EmpNameA,
    required this.EmpType,
    required this.IsNotify,
    required this.IsApprove,
    required this.IsDecision,
    required this.StatusA,
    required this.StatusE,
  });

  factory ClearanceNotify.fromJson(Map<String, dynamic> json) {
    return ClearanceNotify(
      EmpClearanceRequestID: json['EmpClearanceRequestID'].toString() ?? '',
      RequestDate: json['RequestDate'] ?? '',
      FK_EmpCode: json['FK_EmpCode'] ?? '',
      RequestDetails: json['RequestDetails'] ?? '',
      EmpNameE: json['EmpNameE'] ?? '',
      EmpNameA: json['EmpNameA'] ?? '',
      EmpType: json['EmpType'] ?? '',
      IsNotify: json['IsNotify'] ?? '',
      IsApprove: json['IsApprove'] ?? '',
      IsDecision: json['IsDecision'] ?? '',
      StatusA: json['StatusA'] ?? '',
      StatusE: json['StatusE'] ?? '',
    );
  }
}
