class AttendanceModel {
  static const String tableName = 'attendance';
  static const String colId = 'id';
  static const String colEmpCode = 'emp_code';
  static const String colEmpCheckInDate = 'emp_check_in';
  static const String colEmpCheckOutDate = 'emp_check_out';
  static const String colCurrentDate = 'current_date';
  int? id;
  String? empCode;
  String? empCheckInDate;
  String? empCheckOutDate;
  String? currentDate;

  AttendanceModel({
    this.id,
    this.empCode,
    this.empCheckInDate,
    this.empCheckOutDate,
    this.currentDate,
  });

  AttendanceModel.fromMap(Map<String, dynamic> json) {
    id = json[colId];
    empCode = json[colEmpCode];
    empCheckInDate = json[colEmpCheckInDate];
    empCheckOutDate = json[colEmpCheckOutDate].toString();
    currentDate = json[colCurrentDate];
  }

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    id = json['InOutSignID'];
    empCode = json['FK_EmpCode'];
    empCheckInDate = json['InTime'];
    empCheckOutDate = "";
    currentDate = json['Date'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      colEmpCode: empCode,
      colEmpCheckInDate: empCheckInDate,
      colEmpCheckOutDate: empCheckOutDate.toString(),
      colCurrentDate: currentDate,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
