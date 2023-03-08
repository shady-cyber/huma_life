import 'package:easy_localization/easy_localization.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/model/clearance_charge.dart';
import 'package:huma_life/Data/model/clearance_main.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';

class EmployeeClearance extends StatefulWidget {
  const EmployeeClearance({Key? key}) : super(key: key);

  @override
  _EmployeeClearanceScreen createState() => _EmployeeClearanceScreen();
}

class _EmployeeClearanceScreen extends State<EmployeeClearance> {
  String loan = 'Normal Loan';
  String loanMonth = 'january';
  bool _enabled = true;
  String clearance_enabled = '';
  bool pressAttentionChangeColor = false;
  EasyTableModel<ClearanceMain>? _model;
  EasyTableModel<ClearanceCharge>? _modelCharge;

  @override
  void initState() {
    super.initState();
    try {
      clearance_enabled = Provider
          .of<AccountProvider>(context, listen: false)
          .authRepo
          .sharedPreferences
          .getString("Clearance_Enable")!;
    }catch(e){}
    Provider.of<ClearanceProvider>(context, listen: false).getClearanceList().then((value) {
        List<ClearanceMain> rows = Provider.of<ClearanceProvider>(context, listen: false).clearanceData;
        setState(() {
        _model = EasyTableModel<ClearanceMain>(rows: rows, columns: [
          EasyTableColumn(name: 'Asset Category'.tr(),
              stringValue: (row) => row.AssetCategoryDescE,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.centerLeft,
              resizable: true),
          EasyTableColumn(name: 'Asset'.tr(),
              stringValue: (row) => row.AssetCode,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.centerLeft),
          EasyTableColumn(name: 'Qty'.tr(),
              stringValue: (row) => row.Qty,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.centerLeft),
          ]);
        });
      });

    Provider.of<ClearanceProvider>(context, listen: false).getClearanceChargeList().then((value) {
      List<ClearanceCharge> rows = Provider.of<ClearanceProvider>(context, listen: false).clearanceChargeData;
      setState(() {
        _modelCharge = EasyTableModel<ClearanceCharge>(rows: rows, columns: [
          EasyTableColumn(name: 'Charge'.tr(),
              stringValue: (row) => row.ChargeDescE,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.centerLeft,
              resizable: true),
          EasyTableColumn(name: 'Value'.tr(),
              stringValue: (row) => row.Value,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.centerLeft),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Clearance Center'.tr(),
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            )),
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
                child:
                Provider.of<ClearanceProvider>(context, listen: false).clearanceData.length != 0 ?
                Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Clearance Request Information'.tr(),
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

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'My Assets'.tr(),
                        style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'sheriff',
                            color: Colors.black),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    SizedBox(
                      height: 150,
                      child: Container(
                        child: EasyTable<ClearanceMain>(_model,columnWidthBehavior: ColumnWidthBehavior.fit),
                      ),
                    ),

                    const SizedBox(
                      height: 30.0,
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'My Charges'.tr(),
                        style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'sheriff',
                            color: Colors.black),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    SizedBox(
                      height: 150,
                      child: Container(
                        child: EasyTable<ClearanceCharge>(_modelCharge,columnWidthBehavior: ColumnWidthBehavior.fit),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    Consumer<ClearanceProvider>(
                      builder: (context, ClearanceProvider provider, child) {
                        if(clearance_enabled == "false"){
                          _enabled = false;
                        }
                        return ButtonGlobal(
                          buttontext: clearance_enabled != "false" ? 'Submit'.tr() : 'Done Before'.tr(),
                          buttonDecoration: kButtonDecoration.copyWith(
                            color: clearance_enabled != "false" ? pressAttentionChangeColor ? Colors.grey : kMainColor : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              pressAttentionChangeColor = !pressAttentionChangeColor;
                            });
                            _enabled ?
                              {
                              provider.sendClearanceRequest(context: context).then((status) {
                                if (status.isSuccess) {
                                  _enabled = false;
                                  Provider.of<AccountProvider>(context, listen: false).authRepo.sharedPreferences.setString("Clearance_Enable", "false");

                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(SnackBar(content: Text(
                                    'Clearance request sent successfully'.tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 1),
                                  )).closed.then(
                                        (value) {
                                          setState(() {
                                            pressAttentionChangeColor = !pressAttentionChangeColor;
                                          });
                                          Navigator.pop(context);
                                        }
                                  );
                                } else {
                                  _enabled = true;
                                  setState(() {
                                    pressAttentionChangeColor = !pressAttentionChangeColor;
                                  });
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(SnackBar(content: Text(
                                    'Clearance request sending error'.tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 1),
                                  ));
                                }
                              }),
                            } : pressAttentionChangeColor = !pressAttentionChangeColor;
                          },
                        );
                      },
                    ),
                  ],
                ) :
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Center(
                    child: Text(
                      'You Do Not Have Clearance Items'.tr(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
