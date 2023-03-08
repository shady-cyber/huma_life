import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Admin/screens/Management/MarkAttendance.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';
import 'package:huma_life/Common/Util/shimmer.dart';
import 'package:huma_life/Common/Util/constant.dart';

class AttendanceEmployeeList extends StatefulWidget {
  const AttendanceEmployeeList({Key? key}) : super(key: key);

  @override
  _AttendanceEmployeeListState createState() => _AttendanceEmployeeListState();
}

class _AttendanceEmployeeListState extends State<AttendanceEmployeeList> {
  final dateController = TextEditingController();
  String emp_name = "";
  bool checkCard = false;
  bool showProgress = false;
  bool _enabled = true;
  String formattedCurrentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    setState(() {
        AppWidget().initAttendanceEmployee(context, showProgress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Provider.of<EmployeeProvider>(context, listen: false).clearData();
        },
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Employee List'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        reverse: true,
        child: Consumer<EmployeeProvider>(
            builder: (context, employeeProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),

              Container(
                height: MediaQuery.of(context).size.height,
                width: context.width(),
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  color: Colors.white,
                ),

                child: Visibility(
                  visible: true,
                  child: !employeeProvider.showList?
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Center(
                      child: Text(
                        'Loading ...'.tr(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ):
                  employeeProvider.employeeModel.length != 0 ?
                  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 120.0,
                            ),
                              AppTextField(
                                textFieldType: TextFieldType.NAME,
                                readOnly: true,
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));
                                  employeeProvider.selectedDate = date!;
                                },
                                controller: dateController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    suffixIcon: Icon(
                                      Icons.date_range_rounded,
                                      color: kGreyTextColor,
                                    ),
                                    labelText: 'Date'.tr(),
                                    hintText: formattedCurrentDate),
                              ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 3),
                                    child: GestureDetector(
                                      onTap: () {
                                          setState(() => _enabled = false);
                                          employeeProvider.addEmpCards(context);
                                          if(employeeProvider.userCheckedCards.isEmpty){
                                          setState(() {
                                              checkCard = true;
                                              employeeProvider.removeCheckedCard = false;
                                              employeeProvider.mark = !employeeProvider.mark;
                                              employeeProvider.statusCancel = false;
                                          _enabled = true;
                                          });
                                            } else {
                                                employeeProvider.printEmpCard();
                                                _enabled = true;
                                            }
                                          },

                                      child: Container(
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          border: Border.all(color: kMainColor),
                                          color:
                                          employeeProvider.userCheckedCards.isEmpty
                                              ? Colors.white
                                              : kTitleColor,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.credit_card_sharp,
                                              color: employeeProvider
                                                  .userCheckedCards.isEmpty
                                                  ? kTitleColor
                                                  : Colors.white,
                                            ),

                                            const SizedBox(
                                              width: 2.0,
                                            ),

                                            Text(
                                              employeeProvider.userCheckedCards.isEmpty && employeeProvider.removeCheckedCard == true ? 'Cancel Selection'.tr()
                                                  : employeeProvider.userCheckedCards.isNotEmpty && !employeeProvider.removeCheckedCard? 'Print'.tr() :
                                              employeeProvider.userCheckedCards.isEmpty && employeeProvider.removeCheckedCard == false? 'Print Emp Cards'.tr() : '',
                                              style: kTextStyle.copyWith(
                                                  color: employeeProvider
                                                      .userCheckedCards.isEmpty
                                                      ? kTitleColor
                                                      : Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                       ),
                                     ),
                                  ),

                                Expanded(
                                  child: Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        employeeProvider.userChecked.isEmpty
                                            ? setState(() {
                                          checkCard = false;
                                          employeeProvider.removeChecked = false;
                                          employeeProvider.mark = !employeeProvider.mark;
                                        })
                                            : const MarkAttendance().launch(context);
                                      },
                                      child: Container(
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          border: Border.all(color: kMainColor),
                                          color:
                                          employeeProvider.userChecked.isEmpty
                                              ? Colors.white
                                              : kTitleColor,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_outline_rounded,
                                              color: employeeProvider
                                                  .userChecked.isEmpty
                                                  ? kTitleColor
                                                  : Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 2.0,
                                            ),
                                            Text(
                                              employeeProvider.userChecked.isEmpty && employeeProvider.removeChecked == true ? 'Cancel Selection'.tr()
                                                  : employeeProvider.userChecked.isNotEmpty && !employeeProvider.removeChecked? 'Continue'.tr() :
                                              employeeProvider.userChecked.isEmpty && employeeProvider.removeChecked == false? 'Mark Attendance'.tr() : '',
                                              style: kTextStyle.copyWith(
                                                  color: employeeProvider
                                                      .userChecked.isEmpty
                                                      ? kTitleColor
                                                      : Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                   ),

                                      ),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            employeeProvider.isLoading
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[400],
                                      highlightColor: Colors.grey[100],
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0))),
                                        margin: EdgeInsets.only(top: 15),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15, right: 10),
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    height: 8,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Container(
                                                  height: 10,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 15),
                                              height: 200,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: !employeeProvider.mark,
                                    child: Expanded(
                                      flex: 1,
                                      child:  SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: employeeProvider.employeeModel.length,
                                          itemBuilder: (context, i) {
                                            //!employeeProvider.markCard;
                                            Uint8List EmpImg = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
                                            String EmpImgOrig = employeeProvider.employeeModel[i].employeeImage;
                                            if(!EmpImgOrig.startsWith("http")) {
                                               EmpImg = base64Decode(employeeProvider.employeeModel[i].employeeImage);
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                    border: Border.all(
                                                        color: kGreyTextColor
                                                            .withOpacity(0.5)),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      AppWidget().showSheet(context, i, employeeProvider.employeeModel[i].employeeId);
                                                    },
                                                    child: ListTile(
                                                      leading:
                                                      SizedBox(
                                                      width: 50,
                                                      child: EmpImgOrig.startsWith("http") ?
                                                      CachedNetworkImage(
                                                        imageUrl: EmpImgOrig,
                                                        imageBuilder: (context, imageProvider) =>
                                                            Container(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                      ):
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(9.0),
                                                            border: Border.all(color: Colors.white)),

                                                        child: Image.memory(Uint8List.fromList(EmpImg),
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.fill)
                                                      ),
                                                      ),
                                                      title: Text(
                                                        employeeProvider.employeeModel[i].employeeNameA,
                                                        style: kTextStyle,
                                                      ),
                                                      subtitle: Text(
                                                        "Employee".tr(),
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                            kGreyTextColor),
                                                      ),
                                                      trailing: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: kGreyTextColor,
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                            Visibility(
                              visible: employeeProvider.mark,
                              child: Expanded(
                                flex: 1,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  itemCount: employeeProvider.employeeModel.length,
                                  itemBuilder: (context, i) {
                                    //employeeProvider.markCard;
                                    Uint8List EmpImg= Uint8List.fromList([0, 2, 5, 7, 42, 255]);
                                    String EmpImgOrig = employeeProvider.employeeModel[i].employeeImage;
                                    if(!EmpImgOrig.startsWith("http")) {
                                      EmpImg = base64Decode(
                                          employeeProvider
                                              .employeeModel[i]
                                              .employeeImage);
                                    }
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: kGreyTextColor
                                                  .withOpacity(0.5)),
                                        ),
                                        child: CheckboxListTile(
                                          shape: const CircleBorder(),
                                          value: checkCard ? employeeProvider.userCheckedCards
                                              .contains(employeeProvider
                                                  .employeeModel[i].employeeId) :
                                          employeeProvider.userChecked
                                              .contains(employeeProvider
                                              .employeeModel[i].employeeId),
                                          onChanged: (val) {
                                            checkCard ?
                                            employeeProvider.onSelectedCards(
                                                val!, employeeProvider.employeeModel[i].employeeId)
                                            : employeeProvider.onSelected(
                                                val!, employeeProvider.employeeModel[i].employeeId);
                                          },
                                          secondary: EmpImgOrig.startsWith("http") ?
                                          CachedNetworkImage(
                                            imageUrl: EmpImgOrig,
                                            imageBuilder: (context, imageProvider) =>
                                                Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                          ):
                                          Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(9.0),
                                                  border: Border.all(color: Colors.white)),

                                              child: Image.memory(Uint8List.fromList(EmpImg),
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.fill)
                                          ),

                                          title: Text(
                                            employeeProvider
                                                .employeeModel[i].employeeNameA,
                                            style: kTextStyle,
                                          ),
                                          subtitle: Text(
                                            "Employee".tr(),
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Text(
                              'No Employees Under Your Control'.tr(),
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
                  ],
                );
              }),
            ),
          ),
        );
     }
}
