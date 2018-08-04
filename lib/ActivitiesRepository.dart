import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante/DevFestActivity.dart';

class ActivitiesRepository {
  static Stream<List<DevFestActivity>> getActivities() {
    return Firestore.instance
        .collection('talks')
        .snapshots()
        .map((snapshot) => (parserActivity(snapshot)));
  }

  static Stream<List<DevFestActivity>> getActivitiesByDay(int day) {
    return Firestore.instance
        .collection('talks')
        .where("day", isEqualTo: day.toString())
        .snapshots()
        .map((snapshot) => (parserActivity(snapshot)));
  }

  static List<DevFestActivity> parserActivity(QuerySnapshot snapshot) {
    List<DevFestActivity> activities = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];

      if (document["type"] == "generic") {
        // Build new talk
        activities.add(DevFestActivity(
            document["id"],
            document["type"],
            document["title"],
            document["desc"],
            document["day"],
            document["start"],
            document["end"]));
      } else {
        // Build new generic activity
        activities.add(DevFestActivity(
            document["id"],
            document["type"],
            document["title"],
            document["desc"],
            document["day"],
            document["start"],
            document["end"]));

        // TODO: Add speakers later here
      }
    }

    return activities;
  }
}
