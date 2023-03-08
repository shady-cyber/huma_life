import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/screens/Authentication/Sign_In.dart';
import 'package:huma_life/Data/provider/connection_string_provider.dart';

class SelectType extends StatefulWidget {
  const SelectType({Key? key}) : super(key: key);

  @override
  _SelectTypeState createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  final CodeController = TextEditingController();
  late AnimationController controllers;
  bool showTextVerify = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
          body: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Image(image: AssetImage("assets/images/logoinit.png")),
                      const Image(image: AssetImage("assets/images/people.png")),

                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Consumer<ConnectStringProvider>(
                          builder: (context, connectStringProvider, child) {
                            return  Column(
                              children: [
                                Text(
                                  'role'.tr(),
                                  style: kTextStyle.copyWith(
                                      fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  controller: CodeController,
                                  decoration: InputDecoration(
                                    labelText: 'Company Code'.tr(),
                                    labelStyle: kTextStyle,
                                    hintText: 'Enter Company Code'.tr(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: showTextVerify ? Border.all(color: kRedColor) : Border.all(color: kMainColor),
                                    color: showTextVerify ? kDarkWhiteSign : kBgColor,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                      showTextVerify = true;
                                     connectStringProvider.getConnectionUrl(CodeController.text).then((value) => {
                                        if (value == true) {
                                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn())),
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              'Invalid company code number'.tr(),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          )).closed.then((value) {
                                          setState(() {
                                            showTextVerify = false;
                                            CodeController.text = "";
                                              });
                                            }),
                                          }
                                        });
                                      });
                                    },
                                    leading: const Image(
                                      image: AssetImage("assets/images/employee.png"),
                                    ),
                                    title: Text(
                                      showTextVerify ? "Verifying . . ." : 'EmployeeLogin'.tr(),
                                      style: kTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      showTextVerify ? "Your code" : 'descEm'.tr(),
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor, fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
           ),
         ],
       ),
     ),
   );
  }
}
