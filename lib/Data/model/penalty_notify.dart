//model of penalty notification

class PenaltyNotify {
  final int PenaltyRequestID;
  final String RequestDate;
  final String EmpNameE;
  final String EmpNameA;
  final String PenaltyReason;
  final String PenalityDescE;
  final String PenalityDescA;
  final String IsNotify;
  final String IsApprove;
  final String IsDecision;
  final String StatusA;
  final String StatusE;
  final String FK_EmpCode;

  const PenaltyNotify({
    required this.PenaltyRequestID,
    required this.RequestDate,
    required this.EmpNameE,
    required this.EmpNameA,
    required this.PenaltyReason,
    required this.PenalityDescE,
    required this.PenalityDescA,
    required this.IsNotify,
    required this.IsApprove,
    required this.IsDecision,
    required this.StatusA,
    required this.StatusE,
    required this.FK_EmpCode,
  });

  factory PenaltyNotify.fromJson(Map<String, dynamic> json) {
    return PenaltyNotify(
      PenaltyRequestID: json['PenaltyRequestID'] ?? 0,
      RequestDate: json['RequestDate'] ?? '',
      EmpNameE: json['EmpNameE'] ?? '',
      EmpNameA: json['EmpNameA'] ?? '',
      PenaltyReason: json['PenaltyReason'] ?? '',
      PenalityDescE: json['PenalityDescE'] ?? '',
      PenalityDescA: json['PenalityDescA'] ?? '',
      IsNotify: json['IsNotify'] ?? '',
      IsApprove: json['IsApprove'] ?? '',
      IsDecision: json['IsDecision'] ?? '',
      StatusA: json['StatusA'] ?? '',
      StatusE: json['StatusE'] ?? '',
      FK_EmpCode: json['FK_EmpCode'] ?? '',
    );
  }
}
