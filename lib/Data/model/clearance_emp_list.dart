//model of clearance emp list

class ClearanceEmpList {
  final String EmpCode;
  final String EmpNameE;
  final String EmpNameA;
  final String PositionDescE;
  final String PositionDescA;
  final String EmpProfilePhoto;

  const ClearanceEmpList({
    required this.EmpCode,
    required this.EmpNameE,
    required this.EmpNameA,
    required this.PositionDescE,
    required this.PositionDescA,
    required this.EmpProfilePhoto,
  });

  factory ClearanceEmpList.fromJson(Map<String, dynamic> json) {
    return ClearanceEmpList(
      EmpCode: json['EmpCode'].toString(),
      EmpNameE: json['EmpNameE'] ?? '',
      EmpNameA: json['EmpNameA'] ?? '',
      PositionDescE: json['PositionDescE'] ?? '',
      PositionDescA: json['PositionDescA'] ?? '',
      EmpProfilePhoto: json['EmpProfilePhoto'] != '' ? "https://www.w3schools.com/howto/img_avatar.png" :
      "https://www.w3schools.com/howto/img_avatar.png"
    );
  }
}
