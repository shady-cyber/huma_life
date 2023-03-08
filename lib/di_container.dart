import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/provider/attendance_provider.dart';
import 'package:huma_life/Data/provider/cash_provider.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';
import 'package:huma_life/Data/provider/connection_string_provider.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';
import 'package:huma_life/Data/provider/general_req_provider.dart';
import 'package:huma_life/Data/provider/loan_delay_provider.dart';
import 'package:huma_life/Data/provider/loan_provider.dart';
import 'package:huma_life/Data/provider/notification_provider.dart';
import 'package:huma_life/Data/provider/profile_provider.dart';
import 'package:huma_life/Data/provider/vacation_provider.dart';
import 'package:huma_life/Data/repository/attendance_repo.dart';
import 'package:huma_life/Data/repository/cash_repo.dart';
import 'package:huma_life/Data/repository/clearance_repo.dart';
import 'package:huma_life/Data/repository/employee_repo.dart';
import 'package:huma_life/Data/repository/generalRequest_repo.dart';
import 'package:huma_life/Data/repository/loan_delay_repo.dart';
import 'package:huma_life/Data/repository/loan_repo.dart';
import 'package:huma_life/Data/repository/notification_repo.dart';
import 'package:huma_life/Data/repository/profile_repo.dart';
import 'package:huma_life/Data/repository/vacation_repo.dart';
import 'Data/datasource/dio/dio_client.dart';
import 'Data/datasource/dio/logging_interceptor.dart';
import 'Data/provider/penalty_provider.dart';
import 'Data/provider/splash_provider.dart';
import 'Data/repository/auth_repo.dart';
import 'Data/repository/penalty_repo.dart';
import 'Data/repository/splash_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core

  sl.registerLazySingleton(() => DioClient("", sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AttendanceRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => VacationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => LoanRepo(dioClient: sl()));
  sl.registerLazySingleton(() => GeneralRequestRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PenaltyRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CashRepo(dioClient: sl()));
  sl.registerLazySingleton(() => LoanDelayRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ClearanceRepo(dioClient: sl()));
  sl.registerLazySingleton(() => EmployeeRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => ConnectStringProvider(authRepo: sl()));
  sl.registerFactory(() => AccountProvider(authRepo: sl()));
  sl.registerFactory(() => AttendanceProvider(attendanceRepo: sl(), authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(authRepo: sl()));
  sl.registerFactory(() => EmployeeProvider(employeeRepoRepo: sl()));
  sl.registerFactory(() => VacationProvider(vacationRepo: sl()));
  sl.registerFactory(() => LoanProvider(loanRepo: sl()));
  sl.registerFactory(() => GeneralRequestProvider(generalRequestRepo: sl()));
  sl.registerFactory(() => PenaltyProvider(penaltyRepo: sl()));
  sl.registerFactory(() => CashProvider(cashRepo: sl()));
  sl.registerFactory(() => LoanDelayProvider(loanDelayRepo: sl()));
  sl.registerFactory(() => ClearanceProvider(clearanceRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
