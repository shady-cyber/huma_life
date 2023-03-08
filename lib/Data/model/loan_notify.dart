//model of loan request
class LoanNotify {
  final String LoanRequestID;
  final String LoanAmount;
  final String LoanReason;
  final String EmpNameE;
  final String EmpNameA;
  final String FK_EmpCode;
  final String RequestDate;
  final String IsNotify;
  final String IsApprove;
  final String IsDecision;
  final String StatusA;
  final String StatusE;
  final String RequestStatusID;

  const LoanNotify({
    required this.LoanRequestID,
    required this.LoanAmount,
    required this.LoanReason,
    required this.EmpNameE,
    required this.EmpNameA,
    required this.FK_EmpCode,
    required this.RequestDate,
    required this.IsNotify,
    required this.IsApprove,
    required this.IsDecision,
    required this.StatusA,
    required this.StatusE,
    required this.RequestStatusID,
  });

  factory LoanNotify.fromJson(Map<String, dynamic> json) {
    return LoanNotify(
      LoanRequestID: json['LoanRequestID'].toString() ?? '',
      LoanAmount: json['LoanAmount'] ?? '',
      LoanReason: json['LoanReason'] ?? '',
      EmpNameE: json['EmpNameE'] ?? '',
      EmpNameA: json['EmpNameA'] ?? '',
      FK_EmpCode: json['FK_EmpCode'].toString() ?? '',
      RequestDate: json['RequestDate'] ?? '',
      IsNotify: json['IsNotify'] ?? '',
      IsApprove: json['IsApprove'] ?? '',
      IsDecision: json['IsDecision'] ?? '',
      StatusA: json['StatusA'] ?? '',
      StatusE: json['StatusE'] ?? '',
      RequestStatusID: json['RequestStatusID'].toString() ?? '',
    );
  }
}
