//model of clearance assets

class ClearanceSubCharge {
  final String EmpChargeID;
  final String FK_EmpCode;
  final String FK_ChargeID;
  final String Value;
  final String ChargeID;
  final String ChargeDescE;
  final String ChargeDescA;

  const ClearanceSubCharge({
    required this.EmpChargeID,
    required this.FK_EmpCode,
    required this.FK_ChargeID,
    required this.Value,
    required this.ChargeID,
    required this.ChargeDescE,
    required this.ChargeDescA,
  });

  factory ClearanceSubCharge.fromJson(Map<String, dynamic> json) {
    return ClearanceSubCharge(
      EmpChargeID: json['EmpChargeID'].toString() ?? '',
      FK_EmpCode: json['FK_EmpCode'].toString() ?? '',
      FK_ChargeID: json['FK_ChargeID'].toString() ?? '',
      Value: json['Value'].toString() ?? '',
      ChargeID: json['charge']['ChargeID'].toString() ?? '',
      ChargeDescE: json['charge']['ChargeDescE'].toString() ?? '',
      ChargeDescA: json['charge']['ChargeDescA'].toString() ?? '',
    );
  }
}
