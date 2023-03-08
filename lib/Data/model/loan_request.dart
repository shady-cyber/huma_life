//model of loan request
class LoanRequest {
  final String loanType;
  final String amount;
  final String loanReason;
  final String effectiveDate;
  final String monthCount;
  final String Attachment;

  const LoanRequest({
    required this.loanType,
    required this.amount,
    required this.loanReason,
    required this.effectiveDate,
    required this.monthCount,
    required this.Attachment,
  });

  factory LoanRequest.fromJson(Map<String, dynamic> json) {
    return LoanRequest(
      loanType: json['loanType'],
      amount: json['amount'],
      loanReason: json['loanReason'],
      effectiveDate: json['effectiveDate'],
      monthCount: json['monthCount'],
      Attachment: json['Attachment'],
    );
  }
}
