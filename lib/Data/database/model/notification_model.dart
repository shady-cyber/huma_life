class NotificationModel {
  static const String tableName = 'notifications';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colBody = 'body';
  static const String colDate = 'date';
  static const String colTime = 'time';
  static const String colType = 'type';
  static const String colFrom = 'from_user';
  static const String colUserNameE = 'user_nameE';
  static const String colUserNameA = 'user_nameA';
  static const String colIsRead = 'read_at';
  static const String colIsNotify = 'is_notify';
  static const String colIsApprove = 'is_approve';
  static const String colIsDecisions = 'is_decisions';
  static const String colRowId = 'row_id';
  static const String colIsDelete = 'deleted_at';
  static const String colNeedAction = 'need_action';
  int? id;
  String? title;
  String? body;
  String? date;
  String? time;
  String? type;
  String? from;
  String? user_nameA;
  String? user_nameE;
  String? IsNotify;
  String? IsApprove;
  String? IsDecisions;
  String? rowId;
  String? action;
  String? isRead;
  String? isDelete;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.date,
    this.time,
    this.type,
    this.from,
    this.user_nameA,
    this.user_nameE,
    this.IsNotify,
    this.IsApprove,
    this.IsDecisions,
    this.rowId,
    this.action,
    this.isRead,
    this.isDelete,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      colTitle: title,
      colBody: body,
      colFrom: from,
      colUserNameA: user_nameA,
      colUserNameE: user_nameE,
      colDate: date,
      colIsApprove: IsApprove,
      colIsDecisions: IsDecisions,
      colIsNotify: IsNotify,
      colRowId: rowId,
      colNeedAction: action,
      colIsRead: isRead,
      colType: type,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }

  NotificationModel.fromMap(Map<String, dynamic> json) {
    id = json[colId];
    title = json[colTitle];
    body = json[colBody];
    date = json[colDate];
    time = json[colTime];
    type = json[colType];
    from = json[colFrom];
    action = json[colNeedAction];
    isRead = json[colIsRead];
    isDelete = json[colIsDelete];
  }

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    date = json['date'];
    time = json['time'];
    type = json['type'];
    from = json['from_user'].toString();
    user_nameE = json['user_nameE'];
    user_nameA = json['user_nameA'];
    action = json['action'];
    isRead = json['read_at'].toString();
  }
}
