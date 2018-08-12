class DevFestUser {
  String userId;
  String notificationToken;
  List<String> bookmarks = List<String>();

  DevFestUser();
  DevFestUser.create(this.userId, this.notificationToken, this.bookmarks);
}
