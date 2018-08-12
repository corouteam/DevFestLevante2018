import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante/DevFestUser.dart';

class UserRepository {
  final String userId;

  const UserRepository(this.userId);

  createNewUser(DevFestUser user) async {
    await Firestore.instance.collection("users").document(userId).setData({
      "userId": user.userId,
    });
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
    return DevFestUser.create(document["userId"], document["notificationToken"],
        document["bookmarks"]);
  }
}
