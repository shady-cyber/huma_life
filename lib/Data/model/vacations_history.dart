//model of vacation history
class RequestHistory {
  final String requestReason;
  final String requestDecisionMakerNameE;
  final String requestDecisionMakerNameA;
  final String requestDecisionDate;
  final String requestDecisionStatusE;
  final String requestDecisionStatusA;
  final String requestDecisionMakerImage;
  final String requestDecisionMakerTitleE;
  final String requestDecisionMakerTitleA;

  const RequestHistory({
    required this.requestReason,
    required this.requestDecisionMakerNameE,
    required this.requestDecisionMakerNameA,
    required this.requestDecisionDate,
    required this.requestDecisionStatusE,
    required this.requestDecisionStatusA,
    required this.requestDecisionMakerImage,
    required this.requestDecisionMakerTitleE,
    required this.requestDecisionMakerTitleA,
  });

  factory RequestHistory.fromJson(Map<String, dynamic> json) {
    return RequestHistory(
      requestReason: json['StatusComment'] ?? '',
      requestDecisionMakerNameE: json['EmpNameE'] ?? '',
      requestDecisionMakerNameA: json['EmpNameA'] ?? '',
      requestDecisionDate: json['StatusDate'] ?? '',
      requestDecisionStatusE: json['StatusE'] ?? '',
      requestDecisionStatusA: json['StatusA'] ?? '',
      requestDecisionMakerImage: json['EmpProfilePhoto'] == null
          ? 'https://www.w3schools.com/howto/img_avatar.png'
          : json['EmpProfilePhoto'],
      requestDecisionMakerTitleE: json['PositionDescE'] ?? '',
      requestDecisionMakerTitleA: json['PositionDescA'] ?? '',
    );
  }
}
