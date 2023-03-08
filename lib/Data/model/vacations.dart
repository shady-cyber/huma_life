//model of vacation
class Vacation {
  final int vacationId;
  final String vacationNameE;
  final String vacationNameA;

  const Vacation({
    required this.vacationId,
    required this.vacationNameE,
    required this.vacationNameA,
  });

  factory Vacation.fromJson(Map<String, dynamic> json) {
    return Vacation(
      vacationId: json['VacationID'],
      vacationNameA: json['VacationDescA'],
      vacationNameE: json['VacationDescE'],
    );
  }
}
