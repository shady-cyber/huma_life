import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Admin/screens/Management/ClearanceItems.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Data/model/clearance_main.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class ClearanceSubManagement extends StatefulWidget {
  final String EmpCode;
  final bool isDecision;
  final List<ClearanceMain> model;

  ClearanceSubManagement({Key? key, required this.EmpCode, required this.model,required this.isDecision, required int index})
      : super(key: key);

  @override
  _ClearanceSubManagementState createState() =>
      _ClearanceSubManagementState(model, EmpCode, isDecision);
}

class _ClearanceSubManagementState extends State<ClearanceSubManagement> {
  List<ClearanceMain> mList1;
  bool isDecision = true;
  _ClearanceSubManagementState(this.mList1, this.EmpCode, this.isDecision);

  final String EmpCode;
  String Assetcode = "";
  String AssetCategoryDescA = "";
  String AssetCategoryDescE = "";
  String AssetDescE = "";
  String AssetDescA = "";
  String state = "";

  bool isApproved = false;
  bool visibility = false;
  bool Asset = false;
  bool Charge = false;
  bool visibility_charge = false;
  bool pressAttention = false;
  bool visableApprove = true;
  bool pressAttentionChangeColor = false;

  final reasonController = TextEditingController();
  List<DropdownMenuItem<String>> dropdownItems = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
    //  Provider.of<ClearanceProvider>(context, listen: false).getClearanceNotificationList();
      Provider.of<ClearanceProvider>(context, listen: false).getSubClearanceList(EmpCode);
      Provider.of<ClearanceProvider>(context, listen: false).getClearanceListStatusItems();
      Provider.of<ClearanceProvider>(context, listen: false).getSubClearanceChargeList(EmpCode);
      try {
        state = Provider
            .of<AccountProvider>(context, listen: false)
            .authRepo
            .sharedPreferences
            .getString("Enable")!;
      }catch(e){}
    });
  }

  void removeItem(int index) {
    setState(() {
      mList1 = List.from(mList1).removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Provider.of<ClearanceProvider>(context, listen: false)
            .ClearClearanceList();
      },
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Clearance List'.tr(),
            maxLines: 2,
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<ClearanceProvider>(
            builder: (context, clearanceProvider, child) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: kBgColor,
                    ),
                    child: Visibility(
                      visible: true,
                      child: mList1.length != 0 ?
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                                    !clearanceProvider.clearanceNotificationList.isEmpty ?
                                    clearanceProvider.clearanceNotificationList[0].IsDecision == "1"?
                                    Visibility(
                                  visible: !isDecision,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          AppWidget()
                                              .showClearanceSheet(
                                              context,
                                              0,
                                              "2",
                                              EmpCode,
                                              reasonController);
                                        },
                                        child: Container(
                                          width: 120,
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 10.0,
                                              bottom:
                                              10.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  15.0),
                                              color:
                                              kMainColor),
                                          child: Center(
                                            child: Text(
                                              'Approve'.tr(),
                                              style: kTextStyle
                                                  .copyWith(
                                                  color: Colors
                                                      .white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 10.0),
                                      GestureDetector(
                                        onTap: () {
                                          AppWidget()
                                              .showClearanceSheet(
                                              context,
                                              0,
                                              "3",
                                              EmpCode,
                                              reasonController);
                                        },
                                        child: Container(
                                          width: 120,
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 10.0,
                                              bottom:
                                              10.0),
                                          decoration:
                                          BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                15.0),
                                            color: kAlertColor
                                                .withOpacity(
                                                0.1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Reject'.tr(),
                                              style: kTextStyle
                                                  .copyWith(
                                                  color:
                                                  kAlertColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) : Offstage() : Offstage(),
                              SizedBox(
                                height: 10,
                              ),
                                Container(
                                     child: Expanded(
                                      child:
                                     ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: mList1.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                              return ClearanceItems(mList1[index], index, this.EmpCode,
                                              onDelete: () => removeItem(index));
                                          }),
                                     ),
                                   ),
                                 ])
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Center(
                                child: Text(
                                  'No Requests Yet'.tr(),
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
              ]);
        }),
      ),
    );
  }
}
