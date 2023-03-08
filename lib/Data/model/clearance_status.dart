//model of clearance status

class ClearanceStatus {
  final int ClearanceItemStatusID;
  final String ItemStatusDescE;
  final String ItemStatusDescA;

  const ClearanceStatus({
    required this.ClearanceItemStatusID,
    required this.ItemStatusDescE,
    required this.ItemStatusDescA,
  });

  factory ClearanceStatus.initial(Map<String, dynamic> json) {
    return ClearanceStatus(
      ClearanceItemStatusID: json['ClearanceItemStatusID'] = 0,
      ItemStatusDescE: json['ItemStatusDescE'] = 'status',
      ItemStatusDescA: json['ItemStatusDescA'] = 'الحالة',
    );
  }

  factory ClearanceStatus.fromJson(Map<String, dynamic> json) {
    return ClearanceStatus(
      ClearanceItemStatusID: json['ClearanceItemStatusID'],
      ItemStatusDescE: json['ItemStatusDescE'].toString(),
      ItemStatusDescA: json['ItemStatusDescA'].toString(),
    );
  }
}
