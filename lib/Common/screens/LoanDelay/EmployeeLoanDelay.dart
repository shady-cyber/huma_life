import 'package:easy_localization/easy_localization.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/model/loansDelay.dart';
import 'package:huma_life/Data/provider/loan_delay_provider.dart';
import '../../../Data/model/loan_month.dart';

class EmployeeLoanDelay extends StatefulWidget {
  const EmployeeLoanDelay({Key? key}) : super(key: key);

  @override
  _EmployeeLoanDelayScreen createState() => _EmployeeLoanDelayScreen();
}

class _EmployeeLoanDelayScreen extends State<EmployeeLoanDelay> {
  String loan = 'Normal Loan';
  String loanMonth = 'january';
  EasyTableModel<LoansDelay>? _model;
  String _textValue = "";
  bool _enabled = true;
  bool pressAttentionChangeColor = false;

  @override
  void initState() {
    super.initState();

    Provider.of<LoanDelayProvider>(context, listen: false).getLoansDelayList().then((value){
      setState(() {
        List<LoansDelay> rows = Provider.of<LoanDelayProvider>(context, listen: false).loanDelayList;
        _model = EasyTableModel<LoansDelay>(rows: rows, columns: [
          EasyTableColumn(name: 'Loan ID'.tr(), stringValue: (row) => row.EmpLoanMainID,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              resizable: true),
          EasyTableColumn(name: 'Loan Type'.tr(), stringValue: (row) => row.LoanDescE,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center),
          EasyTableColumn(name: 'Start Month'.tr(), stringValue: (row) => row.StartMonth,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center),
          EasyTableColumn(name: 'End Month'.tr(), stringValue: (row) => row.EndMonth,
              headerTextStyle: TextStyle(color: Colors.blue[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center),
        ]);
      });
    });
  }

 // final _monthController = TextEditingController();

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
        title: Text('Loan Delay Request'.tr(),
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
                      'Loan Delay Request Information'.tr(),
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
                      height: 250,
                      child: Container(
                        child: EasyTable<LoansDelay>(_model),
                      ),
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
                                labelText: 'Please Select Your Loan'.tr(),
                                labelStyle: kTextStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: Consumer<LoanDelayProvider>(
                              builder: (context, LoanDelayProvider provider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: provider.monthType,
                                    isDense: true,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        provider.monthType = newValue;
                                        field.didChange(newValue);
                                        Provider.of<LoanDelayProvider>(context, listen: false).getLoanDelayMonthList(provider.monthType);
                                      });
                                    },
                                    items: provider.loanDelayList.map((value) {
                                      provider.amount = value.LoanAmount;
                                      provider.loanId = value.FK_LoanID;
                                      return DropdownMenuItem(
                                        value: value.EmpLoanMainID,
                                        child: Text(value.LoanDescE + ' ( ' + value.StartMonth + ' )'),
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
                                labelText: 'Please Select Month'.tr(),
                                labelStyle: kTextStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: Consumer<LoanDelayProvider>(
                              builder: (context, LoanDelayProvider provider, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: provider.loanMonthType,
                                    isDense: true,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        provider.loanMonthType = newValue;
                                        field.didChange(newValue);
                                      });
                                    },
                                      items:
                                      provider.loanMonthList.map((value){
                                        provider.monthId = value.FK_MonthID;
                                        provider.EmpDetailsId = value.EmpLoanDetailID;
                                        return DropdownMenuItem(
                                          value: value.MonthName,
                                          child: Text(value.MonthName),
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
                    Consumer<LoanDelayProvider>(
                      builder: (context, LoanDelayProvider provider, child) {
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
                            provider.loanMonthList.isEmpty?
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                              'Please Fill all Fields'.tr(),
                              style: TextStyle(color: Colors.white),
                            ),
                              backgroundColor: Colors.red,
                            )).closed.then((value) {
                              _enabled = false;
                              setState(() {
                                pressAttentionChangeColor = !pressAttentionChangeColor;
                               });
                              }
                            ) : {
                              provider.sendLoanDelayRequest(
                                  FK_LoanID: provider.loanId,
                                  amount: provider.amount,
                                  FK_EmpLoanMainID: provider.monthType,
                                  FK_EmpLoanDetailID: provider.EmpDetailsId,
                                  FK_MonthID: provider.monthId,
                                  context: context)
                                  .then((status) {
                                if (status.isSuccess) {
                                  _enabled = false;
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(SnackBar(content: Text(
                                    'Loan Delay request sent successfully'.tr(),
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
                                    'Loan Delay request sending error'.tr(),
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
