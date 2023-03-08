//model of vacation history
class MissedAttendance {
  final String attendanceReason;
  final String attendanceDecisionMakerNameE;
  final String attendanceDecisionMakerNameA;
  final String EmployeePosition;
  final String attendanceRequestID;
  final String EmployeeCode;
  final String AttendanceRequestDate;
  final String AttendanceCheckTime;
  final String AttendanceCheckDate;
  final String FK_InOutSignID;
  final int RequestStatusID;
  final String IsNotify;
  final String IsApprove;
  final String IsDecision;
  final String ReqStatusA;
  final String ReqStatusE;

  const MissedAttendance({
    required this.attendanceReason,
    required this.attendanceDecisionMakerNameE,
    required this.attendanceDecisionMakerNameA,
    required this.EmployeePosition,
    required this.attendanceRequestID,
    required this.EmployeeCode,
    required this.AttendanceRequestDate,
    required this.AttendanceCheckTime,
    required this.AttendanceCheckDate,
    required this.FK_InOutSignID,
    required this.RequestStatusID,
    required this.IsNotify,
    required this.IsApprove,
    required this.IsDecision,
    required this.ReqStatusA,
    required this.ReqStatusE,
  });

  factory MissedAttendance.fromJson(Map<String, dynamic> json) {
    return MissedAttendance(
      attendanceReason: json['MissReason'],
      attendanceDecisionMakerNameE: json['EmpNameE'],
      attendanceDecisionMakerNameA: json['EmpNameA'],
      EmployeePosition: json['EmpType'],
      attendanceRequestID: json['InOutSignRequestID'],
      EmployeeCode: json['FK_EmpCode'],
      FK_InOutSignID: json['FK_InOutSignID'],
      RequestStatusID: int.parse(json['RequestStatusID']),
      IsNotify: json['IsNotify'],
      AttendanceRequestDate: json['RequestDate'],
      AttendanceCheckTime: json['CheckTime'],
      AttendanceCheckDate: json['Date'],
      IsApprove: json['IsApprove'],
      IsDecision: json['IsDecision'],
      ReqStatusA: json['StatusA'],
      ReqStatusE: json['StatusE'],
    );
  }
}
