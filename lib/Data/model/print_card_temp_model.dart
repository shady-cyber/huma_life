//model of vacation
class CardModelTemp {
  final int employeeId;
  final String employeeNameE;
  final String employeeNameA;
  final String employeeJobTitleA;
  final String employeeIqamaNo;
  final String employeeLocationEn;
  final String employeeLocationAr;
  final String employeePositionE;
  final String employeePositionA;
  final String employeeCompanyName;
  final String employeeImage;

  const CardModelTemp({
    required this.employeeId,
    required this.employeeNameE,
    required this.employeeNameA,
    required this.employeeJobTitleA,
    required this.employeeIqamaNo,
    required this.employeeLocationEn,
    required this.employeeLocationAr,
    required this.employeePositionE,
    required this.employeePositionA,
    required this.employeeCompanyName,
    required this.employeeImage,
  });

  factory CardModelTemp.fromJson(Map<String, dynamic> json) {
    return CardModelTemp(
      employeeId: json['EmpCode'] == null ? '' : json['EmpCode'],
      employeeNameA: json['EmpNameA'] == null ? '' : json['EmpNameA'],
      employeeNameE: json['EmpNameE'] == null ? '' : json['EmpNameE'],
      employeeJobTitleA: json['EmpType'] == null ? '' : json['EmpType'],
      employeeIqamaNo: json['IqamaNo'] == null ? '' : json['IqamaNo'],
      employeeLocationEn: json['locationEn'] == null ? '' : json['locationEn'],
      employeeLocationAr: json['locationAr'] == null ? '' : json['locationAr'],
      employeePositionE: json['PositionDescE'] == null ? '' : json['PositionDescE'],
      employeePositionA: json['PositionDescA'] == null ? '' : json['PositionDescA'],
      employeeCompanyName: json['companyName'] == null ? '' : json['companyName'],
      employeeImage: json['EmpProfilePhoto'] == null || json['EmpProfilePhoto'] == ""
          ? 'https://www.w3schools.com/howto/img_avatar.png'
          : json['EmpProfilePhoto'],
    );
  }

}
