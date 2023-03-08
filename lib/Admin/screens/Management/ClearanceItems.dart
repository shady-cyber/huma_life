import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/model/clearance_main.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';

class ClearanceItems extends StatefulWidget {
  final ClearanceMain model;
  final VoidCallback onDelete;
  final String EmpCode;

  ClearanceItems(this.model, int index, this.EmpCode, {required this.onDelete});

  @override
  ClearanceItemsState createState() => new ClearanceItemsState(model, EmpCode);
}

class ClearanceItemsState extends State<ClearanceItems> {
  bool visibility = false;
  bool _enabled = true;
  late ClearanceMain model;
  final String EmpCode;
  String state = "";
  String buttonText = "Submit".tr();
  bool pressAttentionChangeColor = false;
  final reasonController = TextEditingController();
  bool pressAttention = false;
  dynamic selectedValue = 0;

  ClearanceItemsState(this.model, this.EmpCode);

  @override
  void initState() {
    try {
      state = Provider
          .of<AccountProvider>(context, listen: false)
          .authRepo
          .sharedPreferences
          .getString(model.EmployeeItemID)!;
    }catch(e){
      state = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    model.IsAsset == true
                        ? Text('ASSETS',
                        style: boldTextStyle())
                        .paddingAll(16)
                        : Text('CHARGE',
                        style: boldTextStyle())
                        .paddingAll(16),
                    Divider(
                        height: 0,
                        indent: 16,
                        endIndent: 16),
                    Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context)
                                .size
                                .width,
                            padding: const EdgeInsets.all(
                                10.0),
                            decoration: AppWidget()
                                .boxDecorations(
                                bgColor: Colors.white,
                                radius: 20,
                                showShadow: true),
                            child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      model.IsAsset == true ?
                                      AppWidget().text(
                                          model.AssetCode,
                                          fontFamily:
                                          'Medium') :
                                      AppWidget().text(
                                          Provider.of<AccountProvider>(context, listen: false)
                                              .authRepo
                                              .getLang() ==
                                              'ar'
                                              ? model.ItemDescA
                                              : model.ItemDescE,
                                          fontFamily:
                                          'Medium'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      AppWidget().text(
                                          model.Qty,
                                          textColor:
                                          kGreyTextColor),
                                    ],
                                  ),
                                  state == "0" ?
                                  Visibility(
                                    visible: visibility,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets
                                                .all(
                                                10.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child:
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                height: 50.0,
                                                                child: AppWidget().text(Provider.of<AccountProvider>(context, listen: false).authRepo.getLang() == 'ar' ?
                                                                    model.ItemDescA : model.ItemDescE,
                                                                    textColor: kGreyTextColor),
                                                              ),
                                                              const Spacer(),
                                                              Container(
                                                                width: 160,
                                                                height: 50.0,
                                                                child: DropdownButton(
                                                                  value: selectedValue,
                                                                  onChanged: (dynamic value) {
                                                                    setState(() {
                                                                      selectedValue = value;
                                                                    });
                                                                  },
                                                                  items: Provider.of<ClearanceProvider>
                                                                    (context, listen: false).clearanceStatusData
                                                                      .map((value) {
                                                                    return DropdownMenuItem(
                                                                      value: value.ClearanceItemStatusID,
                                                                      child: Text(Provider.of<AccountProvider>(context, listen: false).authRepo.getLang() == 'ar' ?
                                                                      value.ItemStatusDescA : value.ItemStatusDescE),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                              child: TextFormField(
                                                                maxLines: 1,
                                                                controller: reasonController,
                                                                style: TextStyle(
                                                                  fontSize: textSizeMedium,
                                                                  fontFamily: fontRegular,
                                                                ),
                                                                decoration: InputDecoration(
                                                                  contentPadding: EdgeInsets.fromLTRB(spacing_standard_new, 16, 4, 16),
                                                                  hintText: "item evaluation reason".tr(),
                                                                  filled: true,
                                                                  fillColor: kDarkWhite,
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(spacing_middle),
                                                                    borderSide: BorderSide(color: kDarkWhite, width: 0.0),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(spacing_middle),
                                                                    borderSide: BorderSide(color: kDarkWhite, width: 0.0),
                                                                  ),
                                                                ),
                                                              )),
                                                          16.height,
                                                          ButtonGlobal(
                                                            buttonDecoration: kButtonDecoration.copyWith(
                                                              color: pressAttention ? Colors.grey : kMainColor,
                                                            ),
                                                            buttontext: buttonText,
                                                            onPressed: () {
                                                              setState(() {
                                                                pressAttentionChangeColor = !pressAttentionChangeColor;
                                                              });
                                                              _enabled ?
                                                              reasonController.text.isEmpty || selectedValue == '0' ?
                                                              ScaffoldMessenger.of(context)
                                                                  .showSnackBar(SnackBar(
                                                                content: Text(
                                                                  'Please Fill all Fields'.tr(),
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                                backgroundColor: Colors.red,
                                                                duration: Duration(seconds: 1),
                                                              ))
                                                                  .closed
                                                                  .then((value) {
                                                                Navigator.pop(context);
                                                              })  : {
                                                                Provider.of<ClearanceProvider>(context, listen: false).
                                                                sendEvaluationClearanceItems(empCode: int.parse(EmpCode),
                                                                    FK_ItemStatus: selectedValue.toString(),
                                                                    Remarks: reasonController.text, IsAsset: model.IsAsset, IsCharge: model.IsCharge, context: context)
                                                                    .then((status) {
                                                                  if (status.isSuccess) {
                                                                    setState((){
                                                                      _enabled = false;
                                                                      pressAttention = !pressAttention;
                                                                      buttonText = 'Evaluated'.tr();
                                                                      pressAttentionChangeColor = !pressAttentionChangeColor;
                                                                      Provider.of<ClearanceProvider>(context, listen: false).ClearClearanceList();
                                                                    });
                                                                    Provider.of<AccountProvider>(context, listen: false).authRepo.sharedPreferences.setString(model.EmployeeItemID, "false");

                                                                    ScaffoldMessenger.of(context)
                                                                        .showSnackBar(SnackBar(
                                                                      content: Text(
                                                                        'Item Evaluated successfully'.tr(),
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                      backgroundColor: Colors.green,
                                                                      duration: Duration(seconds: 1),
                                                                    ))
                                                                        .closed
                                                                        .then((value) {
                                                                      setState(() {
                                                                        pressAttentionChangeColor = !pressAttentionChangeColor;
                                                                        Provider.of<ClearanceProvider>(context, listen: false).ClearClearanceList();
                                                                      });
                                                                      Navigator.pop(context);
                                                                    });
                                                                  } else {
                                                                    _enabled = true;
                                                                    setState(() {
                                                                      pressAttentionChangeColor = !pressAttentionChangeColor;
                                                                    });
                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                      content: Text(
                                                                        'request sending error'.tr(),
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                      backgroundColor: Colors.red,
                                                                      duration: Duration(seconds: 1),
                                                                    ));
                                                                  }
                                                                }),
                                                              } : pressAttentionChangeColor = !pressAttentionChangeColor;
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      visibility = !visibility;
                                                    });
                                                  },
                                                  child: Align(
                                                    alignment:
                                                    Alignment.center,
                                                    child:
                                                    Icon(
                                                      Icons.keyboard_arrow_up,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    replacement:
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          visibility = !visibility;
                                        });
                                      },
                                      child: Align(
                                        alignment:
                                        Alignment
                                            .center,
                                        child: Icon(
                                          Icons
                                              .keyboard_arrow_down,
                                          color:
                                          kGreyTextColor,
                                        ),
                                      ),
                                    ),
                                  ) :
                                    Center(
                                      child: Text(
                                        'Evaluated'.tr(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green
                                        ),
                                      ),
                                   ),
                                ]),
                            ),
                        ]),
                    16.height,
                  ]),
              ),
          ]),
      );
  }
}
