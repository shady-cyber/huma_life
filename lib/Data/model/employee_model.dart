//model of vacation
class EmployeeModel {
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

  const EmployeeModel({
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

  factory EmployeeModel.initial(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['EmpCode'] = 0,
      employeeNameA: json['EmpNameA'] = 'اختر اسم الموظف',
      employeeNameE: json['EmpNameE'] = 'Please Select Employee Name',
      employeeJobTitleA: json['EmpType'] = '',
      employeeIqamaNo: json['IqamaNo'] = '',
      employeeLocationEn: json['locationEn'] = '',
      employeeLocationAr: json['locationAr'] = '',
      employeePositionE: json['PositionDescE'] = '',
      employeePositionA: json['PositionDescA'] = '',
      employeeCompanyName: json['companyName'] = '',
      employeeImage: json['EmpProfilePhoto'] = 'https://www.w3schools.com/howto/img_avatar.png',
    );
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['EmpCode'] == null ? '' : json['EmpCode'],
      employeeNameA: json['EmpNameA'] == null ? 'اختار اسم الموظف' : json['EmpNameA'],
      employeeNameE: json['EmpNameE'] == null ? 'Please Select Employee Name' : json['EmpNameE'],
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
