//model of clearance assets

import 'package:provider/provider.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';

class ClearanceMain {
  final String EmployeeItemID;
  final String FK_EmpCode;
  final String FK_ItemID;
  final String Qty;
  final String ItemID;
  final String AssetCode;
  final String ItemDescE;
  final String ItemDescA;
  final bool IsAsset;
  final bool IsCharge;
  final String AssetCategoryDescE;
  final String AssetCategoryDescA;

  const ClearanceMain({
    required this.EmployeeItemID,
    required this.FK_EmpCode,
    required this.FK_ItemID,
    required this.Qty,
    required this.ItemID,
    required this.AssetCode,
    required this.ItemDescE,
    required this.ItemDescA,
    required this.IsAsset,
    required this.IsCharge,
    required this.AssetCategoryDescE,
    required this.AssetCategoryDescA,
  });

  factory ClearanceMain.fromJson(Map<String, dynamic> json) {
    return ClearanceMain(
      EmployeeItemID: json['EmployeeAssetID'].toString() ?? '',
      FK_EmpCode: json['FK_EmpCode'].toString() ?? '',
      FK_ItemID: json['FK_AssetID'].toString() ?? '',
      Qty: json['Qty'].toString() ?? '',
      ItemID: json['asset']['AssetID'].toString() ?? '',
      AssetCode: json['asset']['AssetCode'].toString() ?? '',
      ItemDescE: json['asset']['AssetDescE'].toString() ?? '',
      ItemDescA: json['asset']['AssetDescA'].toString() ?? '',
      IsAsset: true,
      IsCharge: false,
      AssetCategoryDescE: json['asset']['asset_category']['AssetCategoryDescE'].toString() ?? '',
      AssetCategoryDescA: json['asset']['asset_category']['AssetCategoryDescA'].toString() ?? '',
    );
  }

  factory ClearanceMain.fromJsonCharge(Map<String, dynamic> json) {
    return ClearanceMain(
      EmployeeItemID: json['EmpChargeID'].toString() ?? '',
      FK_EmpCode: json['FK_EmpCode'].toString() ?? '',
      FK_ItemID: json['FK_ChargeID'].toString() ?? '',
      Qty: json['Value'].toString() ?? '',
      AssetCode: json['AssetCode'].toString() ?? '',
      ItemID: json['charge']['ChargeID'].toString() ?? '',
      ItemDescE: json['charge']['ChargeDescE'].toString() ?? '',
      ItemDescA: json['charge']['ChargeDescA'].toString() ?? '',
      IsAsset: false,
      IsCharge: true,
      AssetCategoryDescE: '',
      AssetCategoryDescA: '',
    );
  }
}
