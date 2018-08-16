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
        // Build new generic
        activities.add(DevFestActivity.generic(
            document["id"],
            document["type"],
            document["title"],
            document["desc"],
            document["cover"],
            document["location"],
            document["day"],
            document["start"],
            document["end"], ""));
      } else if(document["type"] == "talk"){
        // Build new talk/workshop
        activities.add(DevFestActivity(
            document["id"],
            document["type"],
            document["title"],
            document["desc"],
            document["cover"],
            document["location"],
            document["day"],
            document["start"],
            document["end"],
            document["speakers"],
            document["abstract"]));
      }else{
        activities.add(DevFestActivity(
            document["id"],
            document["type"],
            document["title"],
            document["desc"],
            document["cover"],
            document["location"],
            document["day"],
            document["start"],
            document["end"],
            document["speakers"],
            document["abstract"]));
      }
    }

    return activities;
  }
}
