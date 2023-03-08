//model of loanMonths
class LoanMonth {
  final String MonthID;
  final String MonthName;
  final String MonthNameA;
  final String EmpLoanDetailID;
  final String FK_MonthID;

  const LoanMonth({
    required this.MonthID,
    required this.MonthName,
    required this.MonthNameA,
    required this.EmpLoanDetailID,
    required this.FK_MonthID,
  });

  factory LoanMonth.initial(Map<String, dynamic> json) {
    return LoanMonth(
      MonthID: json['MonthID'] = '0',
      MonthName: json['MonthName'] = 'Please Select month',
      MonthNameA: json['MonthNameA'] = 'اختار الشهر',
      EmpLoanDetailID: json['EmpLoanDetailID'] = '',
      FK_MonthID: json['FK_MonthID'] = '',
    );
  }

  factory LoanMonth.fromJson(Map<String, dynamic> json) {
    return LoanMonth(
      MonthID: json['MonthID'].toString() ?? '',
      MonthName: json['MonthName'] ?? '',
      MonthNameA: json['MonthNameA'] ?? '',
      EmpLoanDetailID: json['EmpLoanDetailID'].toString() ?? '',
      FK_MonthID: json['FK_MonthID'].toString() ?? '',
    );
  }
}
