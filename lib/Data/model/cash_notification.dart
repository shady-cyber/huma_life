//model of cash notification request
class CashNotify {
  final String EmpCashRequestID;
  final String LoanAmount;
  final String EmpNameE;
  final String EmpNameA;
  final String RequestDate;
  final String FK_EmpCode;
  final String IsNotify;
  final String IsApprove;
  final String IsDecision;
  final String StatusA;
  final String StatusE;
  final String RequestStatusID;

  const CashNotify({
    required this.EmpCashRequestID,
    required this.LoanAmount,
    required this.EmpNameE,
    required this.EmpNameA,
    required this.RequestDate,
    required this.FK_EmpCode,
    required this.IsNotify,
    required this.IsApprove,
    required this.IsDecision,
    required this.StatusA,
    required this.StatusE,
    required this.RequestStatusID,
  });

  factory CashNotify.fromJson(Map<String, dynamic> json) {
    return CashNotify(
      EmpCashRequestID: json['EmpCashRequestID'].toString() ?? '',
      LoanAmount: json['Amount'] ?? '',
      EmpNameE: json['EmpNameE'] ?? '',
      EmpNameA: json['EmpNameA'] ?? '',
      RequestDate: json['RequestDate'] ?? '',
      FK_EmpCode: json['FK_EmpCode'] ?? '',
      IsNotify: json['IsNotify'] ?? '',
      IsApprove: json['IsApprove'] ?? '',
      IsDecision: json['IsDecision'] ?? '',
      StatusA: json['StatusA'] ?? '',
      StatusE: json['StatusE'] ?? '',
      RequestStatusID: json['RequestStatusID'].toString() ?? '',
    );
  }
}
