//model of loansDelay
class LoansDelay {
  final String EmpLoanMainID;
  final String LoanDescE;
  final String LoanDescA;
  final String StartMonth;
  final String EndMonth;
  final String LoanAmount;
  final String LoanAmountPerMonth;
  final String FK_LoanID;

  const LoansDelay({
    required this.EmpLoanMainID,
    required this.LoanDescE,
    required this.LoanDescA,
    required this.StartMonth,
    required this.EndMonth,
    required this.LoanAmount,
    required this.LoanAmountPerMonth,
    required this.FK_LoanID,
  });

  factory LoansDelay.fromJson(Map<String, dynamic> json) {
    return LoansDelay(
      EmpLoanMainID: json['EmpLoanMainID'].toString() ?? '',
      LoanDescE: json['LoanDescE'] ?? '',
      LoanDescA: json['LoanDescA'] ?? '',
      StartMonth: json['StartMonth'] ?? '',
      EndMonth: json['EndMonth'] ?? '',
      LoanAmount: json['LoanAmount'] ?? '',
      LoanAmountPerMonth: json['AmountPerMonth'] ?? '',
      FK_LoanID: json['FK_LoanID'] ?? '',
    );
  }
}
