import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import '../../../Data/model/attendance_history.dart';

class DecisionAttendanceHistoryList extends StatelessWidget {
  late AttendanceHistory model;
  late int pos;
  String img = "";

  DecisionAttendanceHistoryList(AttendanceHistory model, int pos) {
    this.model = model;
    this.pos = pos;
  }

  @override
  Widget build(BuildContext context) {
    img = model.attendanceDecisionMakerImage;
    var dateFormat = new DateFormat('yyyy-MM-dd HH:mm');
    String decision_date =
        dateFormat.format(DateTime.parse(model.attendanceDecisionDate));

    return Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Container(
          decoration: AppWidget().boxDecorations(
              bgColor: Colors.white, radius: 20, showShadow: true),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl: model.attendanceDecisionMakerImage,
                            width: 50,
                            height: 50,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.attendanceDecisionMakerNameE,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                Text(
                                  decision_date,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  model.attendanceReason,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  model.attendanceDecisionMakerTitleE,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(height: 10),
                    Text(
                      model.attendanceDecisionStatusE,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: model.attendanceDecisionStatusE == "Approved"
                            ? Colors.green
                            : Colors.red,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Container(
                width: 4,
                height: 35,
                margin: EdgeInsets.only(top: 25),
                color: model.attendanceDecisionStatusE == "Approved"
                    ? Colors.green
                    : Colors.red,
              )
            ],
          ),
        ));
  }
}
