import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante/DevFestUser.dart';

class UserRepository {
  final String userId;

  const UserRepository(this.userId);

  createNewUser(DevFestUser user) async {
    await Firestore.instance.collection("users").document(userId).setData({
      "userId": user.userId,
      "email": user.email,
      "displayName": user.displayName,
    });
  }

  addBookmark(String activityId) {
    getUser().listen((user) => _updateBookmarks(user, activityId));
  }

  _updateBookmarks(DevFestUser user, String bookmark) {
    var bookmarksArray = List<dynamic>.from(user.bookmarks);

    if (bookmarksArray == null) {
      bookmarksArray = new List<dynamic>();
    }

    bookmarksArray.add(bookmark);

    Firestore.instance
        .collection("users")
        .document(userId)
        .updateData({"bookmarks": bookmarksArray});
  }

  Stream<DevFestUser> getUser() {
    return Firestore.instance
        .collection('users')
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => (_parseUser(snapshot)));
  }

  static DevFestUser _parseUser(QuerySnapshot snapshot) {
    DocumentSnapshot document = snapshot.documents.first;
    return DevFestUser.create(
        document["userId"],
        document['email'],
        document['displayName'],
        document["notificationToken"],
        document["bookmarks"]);
  }
}
