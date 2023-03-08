//model of vacation history
class AttendanceHistory {
  final String attendanceReason;
  final String attendanceDecisionMakerNameE;
  final String attendanceDecisionMakerNameA;
  final String attendanceDecisionDate;
  final String attendanceDecisionStatusE;
  final String attendanceDecisionStatusA;
  final String attendanceDecisionMakerImage;
  final String attendanceDecisionMakerTitleE;
  final String attendanceDecisionMakerTitleA;

  const AttendanceHistory({
    required this.attendanceReason,
    required this.attendanceDecisionMakerNameE,
    required this.attendanceDecisionMakerNameA,
    required this.attendanceDecisionDate,
    required this.attendanceDecisionStatusE,
    required this.attendanceDecisionStatusA,
    required this.attendanceDecisionMakerImage,
    required this.attendanceDecisionMakerTitleE,
    required this.attendanceDecisionMakerTitleA,
  });

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) {
    return AttendanceHistory(
      attendanceReason: json['StatusComment'],
      attendanceDecisionMakerNameE: json['EmpNameE'],
      attendanceDecisionMakerNameA: json['EmpNameA'],
      attendanceDecisionDate: json['StatusDate'],
      attendanceDecisionStatusE: json['StatusE'],
      attendanceDecisionStatusA: json['StatusA'],
      attendanceDecisionMakerImage: json['EmpProfilePhoto'] == null
          ? 'https://www.w3schools.com/howto/img_avatar.png'
          : json['EmpProfilePhoto'],
      attendanceDecisionMakerTitleE: json['PositionDescE'],
      attendanceDecisionMakerTitleA: json['PositionDescA'],
    );
  }
}
