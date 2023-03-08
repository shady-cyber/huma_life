//model of loans
class Loan {
  final String loanId;
  final String loanDescE;
  final String loanDescA;

  const Loan({
    required this.loanId,
    required this.loanDescE,
    required this.loanDescA,
  });

  factory Loan.initial(Map<String, dynamic> json) {
    return Loan(
      loanId: json['LoanID'] = '0',
      loanDescE: json['LoanDescE'] = 'Please Select loan type',
      loanDescA: json['LoanDescA'] = 'اختار نوع القرض',
    );
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      loanId: json['LoanID'],
      loanDescE: json['LoanDescE'],
      loanDescA: json['LoanDescA'],
    );
  }
}
