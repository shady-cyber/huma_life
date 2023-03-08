import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Common/screens/view/custom_snackbar.dart';
import 'package:huma_life/Data/database/model/attendance_model.dart';
import 'package:huma_life/Data/provider/attendance_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class AttendanceListCheckOut extends StatefulWidget {
  final List<AttendanceModel> model;

  AttendanceListCheckOut(this.model, int index);

  @override
  AttendanceListCheckOutState createState() =>
      AttendanceListCheckOutState(model);
}

class AttendanceListCheckOutState extends State<AttendanceListCheckOut> {
  int selectedPos = 1;
  List<AttendanceModel> mList1;
  AttendanceListCheckOutState(this.mList1);

  @override
  void initState() {
    super.initState();
    selectedPos = 1;
  }

  void removeItem(int index) {
    setState(() {
      mList1 = List.from(mList1)..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar("Attendance Check Out List".tr(),
              icon: "assets/images/qibus_gif_bell.gif", isVisible: true),
          Visibility(
            visible: true,
            child: mList1.length != 0
                ? Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mList1.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return MissingCheckedOut(mList1[index], index,
                              onDelete: () => removeItem(index));
                        }),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Center(
                      child: Text(
                        'Pending For Approval...'.tr(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }

class MissingCheckedOut extends StatefulWidget {
  final AttendanceModel model;
  final VoidCallback onDelete;

  MissingCheckedOut(this.model, int index, {required this.onDelete});

  @override
  MissingCheckedOutState createState() => new MissingCheckedOutState(model);
}

class MissingCheckedOutState extends State<MissingCheckedOut> {
  bool visibility = false;
  String _buttonText = "Check-Out".tr();
  bool _enabled = true;
  String TimeToView = "";
  late AttendanceModel model;
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? selectedDate = DateTime.now();
  bool TimeSelected = false;
  bool pressAttention = false;
  TextEditingController _textEditingController = TextEditingController();
  final dateToController = TextEditingController();
  final TimeToController = TextEditingController();

  void _changed() {
    setState(() {
      visibility = !visibility;
    });
  }

  _selectOutTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        TimeSelected = true;
      });
    }
  }

  MissingCheckedOutState(AttendanceModel model) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppWidget().text("Day".tr(), fontFamily: 'Medium'),
                    AppWidget().text(
                        DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(model.empCheckInDate ?? "")),
                        fontFamily: 'Medium',
                        textColor: kRedColor),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppWidget().text("Check in".tr(), textColor: kGreyTextColor),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: DateFormat("H:m:s a").format(
                                  DateTime.parse(model.empCheckInDate ?? "")),
                              style: TextStyle(
                                  fontSize: 16.0, color: kGreenColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: visibility,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 50.0,
                                        child: AppTextField(
                                          textFieldType: TextFieldType.NAME,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          readOnly: true,
                                          onTap: () async {
                                            _selectOutTime(context);
                                          },
                                          controller: TimeToController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              suffixIcon: Icon(
                                                Icons.access_time,
                                                color: kGreyTextColor,
                                              ),
                                              labelText: 'Time'.tr(),
                                              hintText:
                                                  "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.toString().substring(10, 12)}"),
                                        ),
                                      ),
                                      const Spacer(),
                                      //const SizedBox(width: 20,),
                                      Container(
                                        width: 160,
                                        height: 50.0,
                                        child: AppTextField(
                                          textFieldType: TextFieldType.NAME,
                                          // textAlignVertical: TextAlignVertical.bottom,
                                          readOnly: true,
                                          onTap: () async {
                                            final DateTime? date =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime(2100));
                                            selectedDate = date;
                                            dateToController.text = date
                                                .toString()
                                                .substring(0, 10);
                                          },
                                          controller: dateToController,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 8.0,
                                                  bottom: 8.0,
                                                  top: 10),
                                              border: OutlineInputBorder(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              suffixIcon: Icon(
                                                Icons.date_range_rounded,
                                                color: kGreyTextColor,
                                              ),
                                              labelText: 'Date'.tr(),
                                              hintText: DateFormat("dd/MM/yyyy")
                                                  .format(DateTime.parse(model.empCheckInDate ?? ""))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: TextFormField(
                                        maxLines: 1,
                                        controller: _textEditingController,
                                        style: TextStyle(
                                          fontSize: textSizeMedium,
                                          fontFamily: fontRegular,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              spacing_standard_new, 16, 4, 16),
                                          hintText: "Check out reason".tr(),
                                          filled: true,
                                          fillColor: kDarkWhite,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                spacing_middle),
                                            borderSide: BorderSide(
                                                color: kDarkWhite, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                spacing_middle),
                                            borderSide: BorderSide(
                                                color: kDarkWhite, width: 0.0),
                                          ),
                                        ),
                                      )),
                                  16.height,
                                  ButtonGlobal(
                                    buttonDecoration:
                                        kButtonDecoration.copyWith(
                                      color: pressAttention
                                          ? Colors.grey
                                          : kMainColor,
                                    ),
                                    buttontext: _buttonText,
                                    onPressed: () {
                                      pressAttention = !pressAttention;
                                      if (selectedDate == null) {
                                        showCustomSnackBar(
                                            "Please select the current day".tr(),
                                            context,
                                            isError: true);
                                      }
                                      DateTime? DateTimeOut = DateTime(
                                          this.selectedDate!.year,
                                          this.selectedDate!.month,
                                          this.selectedDate!.day,
                                          selectedTime.hour,
                                          selectedTime.minute);
                                      String DateToSend =
                                          DateFormat("yyyy-MM-dd hh:mm:ss a")
                                              .format(DateTimeOut);
                                      _enabled
                                          ? _textEditingController.text.isEmpty
                                              ? toast("Please enter reason".tr())
                                              : Provider.of<AttendanceProvider>(
                                                      context,
                                                      listen: false)
                                                  .CheckOutOldDay(
                                                      model.currentDate ?? '',
                                                      _textEditingController
                                                          .text,
                                                      DateToSend ?? '',
                                                      model.id ?? 0)
                                                  .then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      visibility = !visibility;
                                                      _buttonText = "Pending".tr();
                                                      _enabled = false;
                                                    });
                                                  }
                                                }) : pressAttention = !pressAttention;
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _changed();
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    replacement: GestureDetector(
                      onTap: () {
                        _changed();
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: kGreyTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  var titleName;
  var icon;
  bool? isVisible = false;
  var isVisibleIcon = false;

  TopBar(var this.titleName, {var this.icon, var this.isVisible});

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    AppWidget().changeStatusColor(kMainColor);
    return SafeArea(
      child: Stack(
        children: [
          Container(color: kMainColor, height: 80),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.15,
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.isVisible!
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back, color: kDarkWhite),
                                onPressed: () {
                                  finish(context);
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                child: AppWidget().text(widget.titleName,
                                    textColor: kDarkWhite,
                                    fontSize: 20.0,
                                    fontFamily: 'Bold'),
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
                            child: AppWidget().text(widget.titleName,
                                textColor: kDarkWhite,
                                fontSize: 20.0,
                                fontFamily: 'Bold'),
                          ),
                    widget.isVisible!
                        ? GestureDetector(
                            onTap: () {
                              // QIBusNotification().launch(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 16.0,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 8.0,
                                right: 16.0,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: context.cardColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
