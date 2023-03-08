import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Data/provider/profile_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Profile'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              width: context.width(),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  Uint8List EmpImg = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
                  String EmpImgOrig = profileProvider.getEmpProfilePhoto();
                  if(EmpImgOrig == ""){
                    EmpImgOrig = 'https://www.w3schools.com/howto/img_avatar.png';
                  }
                  if (!EmpImgOrig.startsWith("https")) {
                    EmpImg = base64Decode(profileProvider.getEmpProfilePhoto());
                    profileProvider.notifyAll();
                  }
                  return Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: 160,
                          height: 160,
                          //padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              border: Border.all(color: Colors.white)),
                          child: EmpImgOrig.startsWith("http")
                              ? CachedNetworkImage(
                            imageUrl: EmpImgOrig,
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration:
                                  BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                             ) : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      9.0),
                                  border: Border.all(
                                      color: Colors
                                          .white)),
                              child: Image.memory(
                                  Uint8List.fromList(EmpImg),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill)),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          readOnly: true,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            labelText: 'Emp Code'.tr(),
                            hintText:
                            profileProvider.getEmpCode(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          readOnly: true,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            labelText: 'Emp Name'.tr(),
                            hintText: profileProvider.authRepo.getLang() == 'ar' ?
                            profileProvider.getEmpUsernameA() : profileProvider.getEmpUsername(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          readOnly: true,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            labelText: 'Emp BirthDay'.tr(),
                            hintText: profileProvider.getEmpBirthDate(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          readOnly: true,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            labelText: 'Manager Name'.tr(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: profileProvider.getEmpManager(),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          readOnly: true,
                          textFieldType: TextFieldType.EMAIL,
                          decoration: InputDecoration(
                            labelText: 'Email Address'.tr(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: profileProvider.getEmpEmail(),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          controller: TextEditingController(),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Phone Number'.tr(),
                            hintText: profileProvider.getEmpMobileNo(),
                            labelStyle: kTextStyle,
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          readOnly: true,
                          textFieldType: TextFieldType.MULTILINE,
                          decoration: InputDecoration(
                            labelText: 'Address'.tr(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: profileProvider.getEmpAddressE(),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Gender'.tr(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: profileProvider.getEmpGender(),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
