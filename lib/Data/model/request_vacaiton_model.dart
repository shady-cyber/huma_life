//model of vacation
class RequestVacationModel {
  final String employeeNameE;
  final String employeeNameA;
  final String VacRequestID;
  final String VacEmpCode;
  final String VacationReasonE;
  final String VacationReasonA;
  final String VacationFrom;
  final String VacationTo;
  final String VacationNote;
  final String VacationStateA;
  final String VacationStateE;
  final String VacationRequestDate;
  final String RequestStatusID;
  final String employeeImage;
  final String IsApproved;
  final String IsDecision;
  final String IsNotify;

  const RequestVacationModel({
    required this.employeeNameE,
    required this.employeeNameA,
    required this.VacRequestID,
    required this.VacEmpCode,
    required this.VacationReasonE,
    required this.VacationReasonA,
    required this.VacationFrom,
    required this.VacationTo,
    required this.VacationNote,
    required this.VacationStateA,
    required this.VacationStateE,
    required this.VacationRequestDate,
    required this.RequestStatusID,
    required this.employeeImage,
    required this.IsApproved,
    required this.IsDecision,
    required this.IsNotify,
  });

  factory RequestVacationModel.fromJson(Map<String, dynamic> json) {
    return RequestVacationModel(
      employeeNameE: json['EmpNameE'],
      employeeNameA: json['EmpNameA'],
      VacRequestID: json['VacRequestID'] ?? '',
      VacEmpCode: json['FK_EmpCode'] ?? '',
      VacationReasonE: json['VacationDescE'],
      VacationReasonA: json['VacationDescA'],
      VacationFrom: json['FromDate'] ?? '',
      VacationTo: json['ToDate'] ?? '',
      VacationNote: json['VacReason'] ?? '',
      VacationStateA: json['StatusA'] ?? '',
      VacationStateE: json['StatusE'] ?? '',
      VacationRequestDate: json['RequestDate'] ?? '',
      RequestStatusID: json['RequestStatusID'] ?? '',
      IsApproved: json['IsApproved'] ?? '',
      IsDecision: json['IsDecision'] ?? '',
      IsNotify: json['IsNotify'] ?? '',
      employeeImage: json['EmpProfilePhoto'] != '' ? "https://www.w3schools.com/howto/img_avatar.png" :
      "https://www.w3schools.com/howto/img_avatar.png"
          // : json['EmpProfilePhoto'],
    );
  }
}
