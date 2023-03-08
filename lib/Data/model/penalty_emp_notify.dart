//model of penalty notification

class PenaltyEmpNotify {
  final int PenaltyRequestID;
  final String RequestDate;
  final String PenaltyReason;
  final String PenalityDescE;
  final String PenalityDescA;
  final String FK_EmpCode;

  const PenaltyEmpNotify({
    required this.PenaltyRequestID,
    required this.RequestDate,
    required this.PenaltyReason,
    required this.PenalityDescE,
    required this.PenalityDescA,
    required this.FK_EmpCode,
  });

  factory PenaltyEmpNotify.fromJson(Map<String, dynamic> json) {
    return PenaltyEmpNotify(
      PenaltyRequestID: json['PenaltyRequestID'] ?? 0,
      RequestDate: json['RequestDate'] ?? '',
      PenaltyReason: json['PenaltyReason'] ?? '',
      PenalityDescE: json['penalty']['PenalityDescE'] ?? '',
      PenalityDescA: json['penalty']['PenalityDescA'] ?? '',
      FK_EmpCode: json['FK_EmpCode'] ?? '',
    );
  }
}
