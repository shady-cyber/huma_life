import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/model/loan.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/provider/loan_provider.dart';
import '../../../Data/model/loan_month.dart';

class EmployeeLoan extends StatefulWidget {
  const EmployeeLoan({Key? key}) : super(key: key);

  @override
  _EmployeeLoanScreen createState() => _EmployeeLoanScreen();
}

class _EmployeeLoanScreen extends State<EmployeeLoan> {
  String loan = 'Normal Loan';
  String loanMonth = 'january';
  String _textValue = "";
  bool _enabled = true;
  bool pressAttentionChangeColor = false;

  @override
  void initState() {
    super.initState();
    Provider.of<LoanProvider>(context, listen: false).getLoanList();
    Provider.of<LoanProvider>(context, listen: false).getLoanMonthList();
  }

  final _amountController = TextEditingController();
  final _monthController = TextEditingController();
  final _reasonController = TextEditingController();
  final _AttachController = TextEditingController();
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
        title: Text('Loan Center'.tr(),
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
                      'Loan Request Information'.tr(),
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
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                labelText: 'Select Loan Type',
                                labelStyle: kTextStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: Consumer<LoanProvider>(
                              builder:
                                  (context, LoanProvider provider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: provider.loanType,
                                    isDense: false,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        provider.loanType = newValue;
                                        field.didChange(newValue);
                                      });
                                    },
                                    items: provider.loanList
                                        .map((value) {
                                      return DropdownMenuItem(
                                        value: value.loanId,
                                        child: Text(
                                            Provider.of<AccountProvider>(context, listen: false).authRepo.getLang() == 'ar' ?
                                            value.loanDescA :
                                            value.loanDescE
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
                    SizedBox(
                      height: 60.0,
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                labelText: 'Select Effective Month'.tr(),
                                labelStyle: kTextStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: Consumer<LoanProvider>(
                              builder: (context, LoanProvider provider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: provider.loanMonthType,
                                    isDense: false,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        provider.loanMonthType = newValue;
                                        field.didChange(newValue);
                                      });
                                    },
                                    items: provider.loanMonthList
                                        .map((value) {
                                      return DropdownMenuItem(
                                        value: value.MonthID,
                                        child: Text(
                                            Provider.of<AccountProvider>(context, listen: false).authRepo.getLang() == 'ar' ?
                                            value.MonthNameA :
                                            value.MonthName),
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
                    SizedBox(
                      height: 60.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NUMBER,
                        controller: _amountController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(
                              Icons.description,
                              color: kGreyTextColor,
                            ),
                            labelText: 'Loan Amount'.tr(),
                            hintText: 'amount'.tr()),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 60.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NUMBER,
                        controller: _monthController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(
                              Icons.description,
                              color: kGreyTextColor,
                            ),
                            labelText: 'Months Count'.tr(),
                            hintText: 'count'.tr()),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 60.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        controller: _reasonController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(
                              Icons.description,
                              color: kGreyTextColor,
                            ),
                            labelText: 'Loan Reason'.tr(),
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

                    Consumer<LoanProvider>(
                      builder: (context, LoanProvider provider, child) {
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
                            _amountController.text.isEmpty || _monthController.text.isEmpty || _reasonController.text.isEmpty
                                || provider.loanType == '0'
                                || provider.loanMonthType == '0'?
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                              'Please Fill all Fields'.tr(),
                              style: TextStyle(color: Colors.white),
                            ),
                              backgroundColor: Colors.red,
                            )).closed.then((value) {
                              _enabled = false;
                              setState(() {
                                pressAttentionChangeColor = !pressAttentionChangeColor;
                                Navigator.pop(context);
                              });
                              }
                            ) : {
                              provider.sendLoanRequest(
                                  effectiveDate: provider.loanMonthType,
                                  amount: _amountController.text,
                                  monthCount: _monthController.text,
                                  loanReason: _reasonController.text,
                                  loanType: provider.loanType,
                                  context: context)
                                  .then((status) {
                                if (status.isSuccess) {
                                  _enabled = false;
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(SnackBar(content: Text(
                                    'Loan request sent successfully'.tr(),
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
                                    'Loan request sending error'.tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 1),
                                  ));
                                }
                              }),
                              /** attachment file upload **/
                              // if(!_AttachController.text.isEmpty){
                              //   Provider.of<VacationProvider>(context, listen: false).uploadFile(_textValue, context);
                              // }
                            } : pressAttentionChangeColor = !pressAttentionChangeColor;
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
