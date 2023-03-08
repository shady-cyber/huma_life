//model of clearance Items Evaluated

class EvaluatedClearanceItems {
  final String EmployeeItemID;
  final bool IsEvaluated;

  const EvaluatedClearanceItems({
    required this.EmployeeItemID,
    required this.IsEvaluated,
  });

  factory EvaluatedClearanceItems.fromJson(Map<String, dynamic> json) {
    return EvaluatedClearanceItems(
      EmployeeItemID: json['EmployeeAssetID'].toString() ?? '',
      IsEvaluated: false,
    );
  }
}
