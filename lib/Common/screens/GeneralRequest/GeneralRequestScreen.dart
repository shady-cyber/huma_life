import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Data/provider/general_req_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class GeneralRequestScreen extends StatefulWidget {
  const GeneralRequestScreen({Key? key}) : super(key: key);

  @override
  _GeneralScreen createState() => _GeneralScreen();
}

class _GeneralScreen extends State<GeneralRequestScreen> {
  String vacation = 'Casual';
  String _textValue = "";
  bool _enabled = true;
  bool pressAttentionChangeColor = false;

  @override
  void initState() {
    super.initState();
  }

  final _titleController = TextEditingController();
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
                  height: 10,
                ),
                Text(
                  'General Request'.tr(),
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
                //   'general_title'.tr(),
                //   style: TextStyle(
                //       fontSize: 15,
                //       decoration: TextDecoration.none,
                //       fontWeight: FontWeight.w400,
                //       fontFamily: 'sheriff',
                //       color: Colors.white),
                // ),
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
                      'General Request Information'.tr(),
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
                      height: 80.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        maxLength: 25,
                        controller: _titleController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(
                              Icons.description,
                              color: kGreyTextColor,
                            ),
                            labelText: 'Request title'.tr(),
                            hintText: 'Title'.tr()),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 80.0,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        maxLength: 30,
                        controller: _desController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(
                              Icons.description,
                              color: kGreyTextColor,
                            ),
                            labelText: 'Description'.tr(),
                            hintText: 'general request reason'.tr()),
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
                            hintText: _textValue == "" ? 'attachment file'.tr()
                                : _AttachController.text = _textValue),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    Consumer<GeneralRequestProvider>(
                    builder: (context, GeneralRequestProvider provider, child) {
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
                        _desController.text.isEmpty || _titleController.text.isEmpty ?
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                          'Please Fill all Fields'.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 1),
                        )).closed.then((value) => _enabled = false,
                        ) : {
                          provider.sendGeneralRequest(
                                  title: _titleController.text,
                                  description: _desController.text,
                                  context: context)
                              .then((status) {
                            if (status.isSuccess) {
                              _enabled = false;
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text(
                                'General request sent successfully'.tr(),
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
