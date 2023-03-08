import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Admin/screens/Home/HomeScreenAdmin.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Employee/screens/Home/HomeScreenEmployee.dart';
import '../../../Data/provider/account_provider.dart';
import '../../../Common/screens/GlobalComponents/button_global.dart';
import 'package:easy_localization/easy_localization.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  final bool exitFromApp = false;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final TextEditingController _empcodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  bool showProgress = false;
  bool pressAttention = false;

  late GlobalKey<FormState> _formKeyLogin;
  late AnimationController controllers;

  @override
  void initState() {
    controllers = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controllers.repeat(reverse: true);
    // TODO: implement initState
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //hide keyboard //
        if (MediaQuery.of(context).viewInsets.bottom != 0) {
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          //Navigator.of(context).pop(false);
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Sign In'.tr(),
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: Consumer<AccountProvider>(
          builder: (context, authProvider, child) => Form(
            key: _formKeyLogin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.0, bottom: 30, right: 25.0),
                  child: Text(
                    'Sign_In_title'.tr(),
                    style: kTextStyle.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 60.0,
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            controller: _empcodeController,
                            decoration: InputDecoration(
                              labelText: 'Code'.tr(),
                              labelStyle: kTextStyle,
                              hintText: 'Enter code'.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppTextField(
                          textFieldType: TextFieldType.PASSWORD,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password'.tr(),
                            labelStyle: kTextStyle,
                            hintText: 'Enter password'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: isChecked,
                                thumbColor: kGreyTextColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              'Save Me'.tr(),
                              style: kTextStyle,
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ButtonGlobal(
                          buttontext: 'Sign In'.tr(),
                          buttonDecoration: kButtonDecoration.copyWith(
                            color: pressAttention ? Colors.grey : kMainColor,
                          ),
                          onPressed: () async {
                            pressAttention = !pressAttention;
                            if (WidgetsBinding
                                    .instance.window.viewInsets.bottom >
                                0.0) {
                              // Keyboard is visible.
                              FocusScope.of(context).unfocus();
                            }
                            String _empcode = _empcodeController.text.trim();
                            String _password = _passwordController.text.trim();
                            if (_empcode.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                    content: Text(
                                      'enter_email_address',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ))
                                  .closed
                                  .then((value) =>
                                      pressAttention = !pressAttention);
                            } else if (_password.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                    content: Text(
                                      'enter_password',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ))
                                  .closed
                                  .then((value) =>
                                      pressAttention = !pressAttention);
                            } else {
                              showProgress = true;
                              authProvider
                                  .login(
                                      employeeCode: _empcode,
                                      password: _password)
                                  .then((status) async {
                                if (status.isSuccess) {
                                  if (authProvider.isActiveRememberMe &&
                                      isChecked) {
                                    authProvider.saveUserNumberAndPassword(
                                        _empcode, _password);
                                  } else {
                                    showProgress = false;
                                  }
                                  if (await Provider.of<AccountProvider>(context, listen: false).isAdmin()) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                          content: Text(
                                            'Success',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 1),
                                        ))
                                        .closed
                                        .then((value) {
                                      pressAttention = !pressAttention;
                                    });

                                    const HomeScreenAdmin().launch(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                          content: Text(
                                            'Success',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 1),
                                        ))
                                        .closed
                                        .then((value) =>
                                            pressAttention = !pressAttention);
                                    const HomeScreenEmployee().launch(context);
                                  }
                                } else {
                                  showProgress = false;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                        content: Text(
                                          status.message,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 1),
                                      ))
                                      .closed
                                      .then((value) {
                                    pressAttention = !pressAttention;
                                  });
                                }
                              });
                            }
                          },
                        ),
                        showProgress ? CircularProgressIndicator(
                                value: controllers.value,
                                semanticsLabel: 'Circular progress indicator',
                              )
                            : const SizedBox(
                                height: 20.0,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
