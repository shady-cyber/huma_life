import 'package:flutter/foundation.dart';
import 'package:huma_life/Data/repository/auth_repo.dart';

class ProfileProvider with ChangeNotifier {
  final AuthRepo authRepo;

  ProfileProvider({required this.authRepo});

  void notifyAll() {
    notifyListeners();
  }

  String getEmpUsername() {
  return authRepo.getEmpUsername();
  }

  String getEmpUsernameA() {
    return authRepo.getEmpUsernameA();
  }

  String getEmpCode() {
    return authRepo.getEmpCode();
  }

  String getEmpAddressA() {
    return authRepo.getEmpAddressA();
  }

  String getEmpAddressE() {
    return authRepo.getEmpAddressE();
  }

  String getEmpEmail() {
    return authRepo.getEmpEmail();
  }

  String getEmpMobileNo() {
    return authRepo.getEmpMobileNo();
  }

  String getEmpBirthDate() {
    return authRepo.getEmpBirthDate();
  }

  String getEmpGender() {
    return authRepo.getEmpGender();
  }

  String getEmpIqamaNo() {
    return authRepo.getEmpIqamaNo();
  }

  String getEmpPositionE() {
    return authRepo.getEmpPositionE();
  }

  String getEmpPositionA() {
    return authRepo.getEmpPositionA();
  }

  String getEmpLocationE() {
    return authRepo.getEmpLocationE();
  }

  String getEmpLocationA() {
    return authRepo.getEmpLocationA();
  }

  String getEmpCompanyName() {
    return authRepo.getEmpCompanyName();
  }

  String getEmpProfilePhoto() {
    return authRepo.getEmpProfilePhoto();
  }

  String getEmpManager() {
    return authRepo.getEmpManager();
  }
}
