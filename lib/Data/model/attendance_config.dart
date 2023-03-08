//model of vacation
class AttendanceConfig {
  final int FK_EmpCode;
  final bool QROption;
  final bool LocationOption;
  final double? Longitude;
  final double? Latitude;

  const AttendanceConfig({
    required this.FK_EmpCode,
    required this.QROption,
    required this.LocationOption,
    required this.Longitude,
    required this.Latitude,
  });

  factory AttendanceConfig.fromJson(Map<String, dynamic> json) {
    return AttendanceConfig(
      FK_EmpCode: json['FK_EmpCode'],
      QROption: json['QROption'],
      LocationOption: json['LocationOption'],
      Longitude: json['Longitude'] == null ? '' : json['Longitude'],
      Latitude: json['Latitude'] == null ? '' : json['Latitude'],
    );
  }
}
