import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../repository/auth_repo.dart';

final sl = GetIt.instance;
class ConnectStringProvider with ChangeNotifier {
  String _connectionString = '';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthRepo authRepo;

  ConnectStringProvider({required this.authRepo});

  Future getConnectionUrl(String passcode) async{
    try{
      //check if internet connection is available
        var result = await firestore.collection('connection_string').doc(passcode).get();
         if (result.exists) {
            _connectionString = result.data()!['url'];
            authRepo.saveConnectionString(_connectionString);
            AppConstants.BASE_URL = _connectionString;

            //remove dio client from di container
            sl.unregister<DioClient>();

            sl.registerLazySingleton(() => DioClient(_connectionString, sl(),
                loggingInterceptor: sl(), sharedPreferences: sl()));

            DioClient dio = sl();
            dio.setBaseUrl(_connectionString);

            notifyListeners();
            return true;
         }
         return false;
    }catch(e){
      print(e);
      return false;
    }
  }


  Future initConfig() async{
    try{
      String connectionString = await authRepo.getConnectionString();
      if(connectionString.isNotEmpty){
        AppConstants.BASE_URL = _connectionString;
        return true;
      }
    }catch(e){
      print(e);
      return false;
    }
  }
}