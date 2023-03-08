class SVNotificationModel {
  int? id;
  String? name;
  String? secondName;
  String? profileImage;
  String? time;
  String? notificationType;
  String? postImage;
  bool? isOfficial;
  String? birthDate;
  String isNotified;
  String IsDecision;
  String IsApprove;

  SVNotificationModel(
      {
      this.id = 0,
      this.name,
      this.profileImage,
      this.time,
      this.notificationType,
      this.postImage,
      this.isOfficial,
      this.secondName,
      this.birthDate,
      required this.isNotified,
      required this.IsDecision,
      required this.IsApprove});
}

class SVNotificationType {
  static String like = 'like';
  static String request = 'request';
  static String birthday = 'birthday';
  static String newPost = 'newPost';
}

class SVPostType {
  static String video = 'video';
  static String camera = 'camera';
  static String voice = 'voice';
  static String location = 'location';
  static String text = 'text';
}
