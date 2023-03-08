//model of loan delay request
class LoanDelayNotify {
  final String EmployeeLoanDelayRequestID;
  final String Amount;
  final String AmountPerMonth;
  final String EmpNameE;
  final String EmpNameA;
  final String LoanDescA;
  final String LoanDescE;
  final String MonthName;
  final String FK_EmpCode;
  final String IsNotify;
  final String IsApprove;
  final String IsDecision;
  final String StatusA;
  final String StatusE;

  const LoanDelayNotify({
    required this.EmployeeLoanDelayRequestID,
    required this.Amount,
    required this.AmountPerMonth,
    required this.EmpNameE,
    required this.EmpNameA,
    required this.LoanDescA,
    required this.LoanDescE,
    required this.MonthName,
    required this.FK_EmpCode,
    required this.IsNotify,
    required this.IsApprove,
    required this.IsDecision,
    required this.StatusA,
    required this.StatusE,
  });

  factory LoanDelayNotify.fromJson(Map<String, dynamic> json) {
    return LoanDelayNotify(
      EmployeeLoanDelayRequestID: json['EmployeeLoanDelayRequestID'].toString() ?? '',
      Amount: json['Amount'] ?? '',
      AmountPerMonth: json['AmountPerMonth'] ?? '',
      EmpNameE: json['EmpNameE'] ?? '',
      EmpNameA: json['EmpNameA'] ?? '',
      LoanDescA: json['LoanDescA'] ?? '',
      LoanDescE: json['LoanDescE'] ?? '',
      MonthName: json['MonthName'] ?? '',
      FK_EmpCode: json['FK_EmpCode'] ?? '',
      IsNotify: json['IsNotify'] ?? '',
      IsApprove: json['IsApprove'] ?? '',
      IsDecision: json['IsDecision'] ?? '',
      StatusA: json['StatusA'] ?? '',
      StatusE: json['StatusE'] ?? '',
    );
  }
}
