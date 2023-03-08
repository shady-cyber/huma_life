//model of clearance assets

class ClearanceCharge {
  final String EmployeeChargeID;
  final String FK_EmpCode;
  final String FK_ChargeID;
  final String Value;
  final String ChargeID;
  final String ChargeCode;
  final String ChargeDescE;
  final String ChargeDescA;
  // final String ChargeCategoryDescE;
  // final String ChargeCategoryDescA;

  const ClearanceCharge({
    required this.EmployeeChargeID,
    required this.FK_EmpCode,
    required this.FK_ChargeID,
    required this.Value,
    required this.ChargeID,
    required this.ChargeCode,
    required this.ChargeDescE,
    required this.ChargeDescA,
    // required this.ChargeCategoryDescE,
    // required this.ChargeCategoryDescA,
  });

  factory ClearanceCharge.fromJson(Map<String, dynamic> json) {
    return ClearanceCharge(
      EmployeeChargeID: json['EmployeeChargeID'].toString(),
      FK_EmpCode: json['FK_EmpCode'].toString(),
      FK_ChargeID: json['FK_ChargeID'].toString(),
      Value: json['Value'].toString(),
      ChargeID: json['charge']['ChargeID'].toString(),
      ChargeCode: json['charge']['ChargeCode'].toString(),
      ChargeDescE: json['charge']['ChargeDescE'].toString(),
      ChargeDescA: json['charge']['ChargeDescA'].toString(),
      // ChargeCategoryDescE: json['charge']['Charge_category']['ChargeCategoryDescE'].toString(),
      // ChargeCategoryDescA: json['charge']['Charge_category']['ChargeCategoryDescA'].toString(),
    );
  }
}
