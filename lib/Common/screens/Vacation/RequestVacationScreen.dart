import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/model/vacations.dart';
import 'package:huma_life/Data/provider/vacation_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class RequestVacationScreen extends StatefulWidget {
  const RequestVacationScreen({Key? key}) : super(key: key);

  @override
  _VacationScreen createState() => _VacationScreen();
}

class _VacationScreen extends State<RequestVacationScreen> {
  String vacation = 'Casual';
  String _textValue = "";
  bool _enabled = true;
  bool pressAttentionChangeColor = false;

  @override
  void initState() {
    super.initState();
    Provider.of<VacationProvider>(context, listen: false).getVacationList();
  }

  final dateFromController = TextEditingController();
  final dateToController = TextEditingController();
  final _desController = TextEditingController();
  final _AttachController = TextEditingController();

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
                  height: 5,
                ),
               Column(
                    children: [
                      Text(
                        'Vacation Request'.tr(),
                        style: TextStyle(
                            fontSize: 25,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sheriff',
                            color: Colors.white),
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'Vacation_title'.tr(),
                      //   style: TextStyle(
                      //       fontSize: 15,
                      //       decoration: TextDecoration.none,
                      //       fontWeight: FontWeight.w400,
                      //       fontFamily: 'sheriff',
                      //       color: Colors.white),
                      // ),
                    ],
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
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                      'Request Vacation Information'.tr(),
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'sheriff',
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 60.0,
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Select Vacation Type'.tr(),
                                labelStyle: kTextStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: Consumer<VacationProvider>(
                              builder:
                                  (context, VacationProvider provider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: provider.vacationType,
                                    isDense: true,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        provider.vacationType = newValue;
                                        field.didChange(newValue);
                                      });
                                    },
                                    items: provider.vacationList
                                        .map((value) {
                                      return DropdownMenuItem(
                                        value: value.vacationId,
                                        child: Text(value.vacationNameE),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
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
                        dateFromController.text =
                            date.toString().substring(0, 10);
                      },
                      controller: dateFromController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(
                            Icons.date_range_rounded,
                            color: kGreyTextColor,
                          ),
                          labelText: 'From Date'.tr(),
                          hintText: 'Date'.tr()),
                    ),
                    const SizedBox(
                      height: 20.0,
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
                        dateToController.text =
                            date.toString().substring(0, 10);
                      },
                      controller: dateToController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(
                            Icons.date_range_rounded,
                            color: kGreyTextColor,
                          ),
                          labelText: 'To Date'.tr(),
                          hintText: 'Date'.tr()),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 60.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        controller: _desController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(
                              Icons.description,
                              color: kGreyTextColor,
                            ),
                            labelText: 'Description'.tr(),
                            hintText: 'vacation reason'.tr()),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 60.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        enabled: false,
                        controller: _AttachController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.attach_file,
                                color: kGreyTextColor,
                              ),
                              onPressed: () {

                              },
                            ),
                            labelText: 'Attachments'.tr(),
                            hintText: _textValue == ""
                                ? 'attachment file'.tr()
                                : _AttachController.text = _textValue),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    Consumer<VacationProvider>(
                    builder: (context, VacationProvider provider, child) {
                    return ButtonGlobal(
                      buttontext: 'Submit'.tr(),
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: pressAttentionChangeColor ? Colors.grey : kMainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          pressAttentionChangeColor = !pressAttentionChangeColor;
                        });
                        _enabled ?
                        dateFromController.text.isEmpty || dateToController.text.isEmpty ?
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                          'Please Fill all Fields'.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 1),
                        )).closed.then((value) => _enabled = false,
                        ) : {
                          provider.sendVacationRequest(
                                  fromDate: dateFromController.text,
                                  toDate: dateToController.text,
                                  reason: _desController.text,
                                  context: context)
                              .then((status) {
                            if (status.isSuccess) {
                              _enabled = false;
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text(
                                'Vacation request sent successfully'.tr(),
                                style: TextStyle(color: Colors.white),
                              ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              )).closed.then(
                                    (value) => Navigator.pop(context),
                              );
                            }
                          }),
                          /** attachment file upload **/
                          // if(!_AttachController.text.isEmpty){
                          //   Provider.of<VacationProvider>(context, listen: false).uploadFile(_textValue, context);
                          // }
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
