//model of penalty
import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/model/penalty.dart';

class Penalty {
  final int PenalityID;
  final String PenalityDescA;
  final String PenalityDescE;
  final String PenalityValue;
  final String PenalityPercent;
  final String PenalityActive;
  final String FK_SalaryBandID;
  final String IsEarlyPenality;
  final String IsLatePenality;
  final String MinutesFrom;
  final String MinutesTo;
  final String IsEditable;
  final String FK_DeductedSalaryBandID;
  final String PenalityHour;

  const Penalty({
    required this.PenalityID,
    required this.PenalityDescA,
    required this.PenalityDescE,
    required this.PenalityValue,
    required this.PenalityPercent,
    required this.PenalityActive,
    required this.FK_SalaryBandID,
    required this.IsEarlyPenality,
    required this.IsLatePenality,
    required this.MinutesFrom,
    required this.MinutesTo,
    required this.IsEditable,
    required this.FK_DeductedSalaryBandID,
    required this.PenalityHour,
  });

  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(
      PenalityID: json['PenalityID'],
      PenalityDescA: json['PenalityDescA'],
      PenalityDescE: json['PenalityDescE'],
      PenalityValue: json['PenalityValue'] ?? '',
      PenalityPercent: json['PenalityPercent'] ?? '',
      PenalityActive: json['PenalityActive'] ?? '',
      FK_SalaryBandID: json['FK_SalaryBandID'] ?? '',
      IsEarlyPenality: json['IsEarlyPenality'] ?? '',
      IsLatePenality: json['IsLatePenality'] ?? '',
      MinutesFrom: json['MinutesFrom'] ?? '',
      MinutesTo: json['MinutesTo'] ?? '',
      IsEditable: json['IsEditable'],
      FK_DeductedSalaryBandID: json['FK_DeductedSalaryBandID'] ?? '',
      PenalityHour: json['PenalityHour'] ?? '',
    );
  }
}
