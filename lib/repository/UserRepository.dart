import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante_2018/model/DevFestUser.dart';

class UserRepository {
  final String userId;

  UserRepository(this.userId);

  createNewUser(DevFestUser user) async {
    await Firestore.instance.collection("users").document(userId).setData({
      "userId": user.userId,
      "email": user.email,
      "displayName": user.displayName,
    }, merge: true);

  }

  addFcmToken(DevFestUser user) async {
    await Firestore.instance.collection("users").document(userId).setData({
      "notificationToken": user.notificationToken,
    }, merge: true);
  }

  addBookmark(String activityId) {
    // Create subscription reference, so we can unsubscribe
    // when we get the current bookmarks
    var subscription = getUser().listen(null);
    subscription.onData((user) {
      if (user != null) {
        // We have the update user, update bookmarks now
        _updateBookmarks(user, activityId, false);

        // We can cancel the subscription to avoid multiple writes on Firebase
        subscription.cancel();
      }
    });
  }

  removeBookmark(String activityId) {
    // Create subscription reference, so we can unsubscribe
    // when we get the current bookmarks
    var subscription = getUser().listen(null);
    subscription.onData((user) {
      if (user != null) {
        // We have the update user, update bookmarks now
        _updateBookmarks(user, activityId, true);

        // We can cancel the subscription to avoid multiple writes on Firebase
        subscription.cancel();
      }
    });
  }

  _updateBookmarks(DevFestUser user, String bookmark, bool delete) {
    // Current bookmarks will go there
    var bookmarksArray;

    if (user.bookmarks == null) {
      // If user has no bookmarks, initialize the array
      bookmarksArray = new List<dynamic>();
    } else {
      // else get current bookmarks
      // List<>.from: returns a NON-FIXED list instead of a fixed one
      bookmarksArray = List<dynamic>.from(user.bookmarks);
    }

    if (delete) {
      // remove bookmark in the current array
      bookmarksArray.removeWhere((item) => item == bookmark);
    } else {
      // add bookmark to the array
      bookmarksArray.add(bookmark);
    }

    // Now that we have the updated bookmarks array we need to push it online
    Firestore.instance.collection("users").document(userId)
        // UpdateData will not touch other user proprieties like id and displayName
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
