import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/model/employee_model.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';
import '../../../Data/provider/penalty_provider.dart';

class EmployeePenalty extends StatefulWidget {
  const EmployeePenalty({Key? key}) : super(key: key);

  @override
  _EmployeePenaltyScreen createState() => _EmployeePenaltyScreen();
}

class _EmployeePenaltyScreen extends State<EmployeePenalty> with TickerProviderStateMixin{
  String vacation = 'Casual';
  String _textValue = "";
  bool _enabled = true;
  bool showProgress = false;
  bool pressAttentionChangeColor = false;

  @override
  void initState() {
    super.initState();
    getlist();
    Provider.of<EmployeeProvider>(context, listen: false).getEmployeeList(context, 'penalty');
  }

  Future<void> getlist() async {
    await Provider.of<PenaltyProvider>(context, listen: false).getPenaltyList(context);
  }

  @override
  void deactivate() {
    PenaltyProvider.selectedValueSingleDialog = "";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _EmployeePenaltyScreen && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
  final penaltyTypeController = TextEditingController();
  final dateController = TextEditingController();
  final _desController = TextEditingController();
  final _AttachController = TextEditingController();
  final formattedCurrentDate = DateFormat('dd-MM-yyyy').
  format(DateTime.now());

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
        title: Text('Penalty Center'.tr(),
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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Penalty Request Information'.tr(),
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
                      height: 70.0,
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                labelText: 'Select Emp Name'.tr(),
                                labelStyle: kTextStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: Consumer<EmployeeProvider>(
                              builder:
                                  (context, EmployeeProvider provider, child) {

                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                       value: provider.initi,
                                       isDense: false,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        provider.initi = newValue;
                                        field.didChange(newValue);
                                      });
                                    },
                                    items: provider.employeeModel
                                        .map((value) {
                                      return DropdownMenuItem(
                                        value: value.employeeId,
                                        child: Text(
                                            Provider.of<AccountProvider>(context, listen: false).authRepo.getLang() == 'ar' ?
                                            value.employeeNameA :
                                            value.employeeNameE
                                        ),
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

                    Row(
                      children: [
                        Expanded(
                          child: SearchChoices.single(
                            items: PenaltyProvider.penaltyList,
                            value: PenaltyProvider.penaltyType,
                            hint:  PenaltyProvider.selectedValueSingleDialog,
                            searchHint: "Select".tr(),
                            displayClearIcon: false,

                            onChanged: (value) {
                              setState(() {
                                  PenaltyProvider.penaltyType =
                                      value.PenalityID;
                                  Provider.of<AccountProvider>(context, listen: false).authRepo.getLang() == 'ar' ?
                                    PenaltyProvider.selectedValueSingleDialog = value.PenalityDescA :
                                    PenaltyProvider.selectedValueSingleDialog = value.PenalityDescE;
                              });
                            },
                            isExpanded: true,
                            autofocus: false,
                            underline: Container(
                              height: 1.0,
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black45, width: 1.0))),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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
                            firstDate: DateTime(1999),
                            lastDate: DateTime(2100));
                        dateController.text =
                            date.toString().substring(0, 10);
                      },
                      controller: dateController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(
                            Icons.date_range_rounded,
                            color: kGreyTextColor,
                          ),
                          labelText: 'AffectiveDate'.tr(),
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
                            labelText: 'Penalty Reason'.tr(),
                            hintText: 'reason'.tr()),
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
                                // Provider.of<VacationProvider>(context,
                                //         listen: false)
                                //     .selectFiles()
                                //     .then((value) => setState(() {
                                //           _textValue = value;
                                //         }));
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

                    Consumer<PenaltyProvider>(
                      builder: (context, PenaltyProvider provider, child) {
                        DateTime now = DateTime.now();
                        String formattedTime = DateFormat('kk:mm:ss').format(now);
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
                            dateController.text.isEmpty || _desController.text.isEmpty || Provider.of<EmployeeProvider>
                              (context, listen: false).initi == 0 ?
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                              'Please Fill all Fields'.tr(),
                              style: TextStyle(color: Colors.white),
                            ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 1),
                            )).closed.then((value) {
                              _enabled = false;
                              Navigator.pop(context);
                              }
                            ) : {
                              provider.sendPenaltyRequest(
                                  RequestedEmpCode: Provider.of<EmployeeProvider>
                                    (context, listen: false).initi.toString(),
                                  penaltyType: PenaltyProvider.penaltyType.toString(),
                                  affectiveDate: dateController.text + ' ' + formattedTime,
                                  penaltyReason: _desController.text,
                                  context: context)
                                  .then((status) {
                                if (status.isSuccess) {
                                  _enabled = false;
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(SnackBar(content: Text(
                                    'Penalty request sent successfully'.tr(),
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
