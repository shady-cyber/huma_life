import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/provider/cash_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class CashInAdvanceScreen extends StatefulWidget {
  const CashInAdvanceScreen({Key? key}) : super(key: key);

  @override
  _CashScreen createState() => _CashScreen();
}

class _CashScreen extends State<CashInAdvanceScreen> {
  bool _enabled = true;
  bool pressAttentionChangeColor = false;

  final _cashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // here the desired height
        child: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Cash Request'.tr(),
                  style: TextStyle(
                      fontSize: 25,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'sheriff',
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Cash Request Information'.tr(),
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'sheriff',
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      height: 60.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NUMBER,
                        controller: _cashController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(
                              Icons.description,
                              color: kGreyTextColor,
                            ),
                            labelText: 'Amount'.tr(),
                            hintText: 'Max Value Is 325'.tr()),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    Consumer<CashProvider>(
                    builder: (context, CashProvider provider, child) {
                    return ButtonGlobal(
                      buttontext: 'Submit'.tr(),
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: pressAttentionChangeColor ? Colors.grey : kMainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          pressAttentionChangeColor = !pressAttentionChangeColor;
                          if (WidgetsBinding
                              .instance.window.viewInsets.bottom >
                              0.0) {
                            // Keyboard is visible.
                            FocusScope.of(context).unfocus();
                          }
                        });
                        _enabled ?
                        _cashController.text.isEmpty?
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                          'Please Fill all Fields'.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 1),
                        )).closed.then((value) => _enabled = false,
                        ) : {
                          provider.sendCashRequest(
                                  amount: _cashController.text,
                                  context: context)
                              .then((status) {
                            if (status.isSuccess) {
                              _enabled = false;
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text(
                                'Cash request sent successfully'.tr(),
                                style: TextStyle(color: Colors.white),
                              ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              )).closed.then(
                                    (value) => Navigator.pop(context),
                                  );
                                }
                              }),
                            }: pressAttentionChangeColor = !pressAttentionChangeColor;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
