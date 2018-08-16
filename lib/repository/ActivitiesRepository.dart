import 'dart:async';

import 'package:devfest_levante_2018/model/DevFestActivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante_2018/model/DevFestUser.dart';

class ActivitiesRepository {
  static Stream<List<DevFestActivity>> getActivities() {
    return Firestore.instance
        .collection('talks')
        .snapshots()
        .map((snapshot) => (activityMapper(snapshot)));
  }

  static Stream<List<DevFestActivity>> getActivitiesByDay(int day) {
    return Firestore.instance
        .collection('talks')
        .where("day", isEqualTo: day.toString())
        .snapshots()
        .map((snapshot) => (activityMapper(snapshot)));
  }

  static getFavouriteActivities(List<dynamic> favourites) {
    return Firestore.instance
        .collection('talks')
        .snapshots()
        .map((snapshot) => (favouriteActivityMapper(snapshot, favourites)));
  }

  static List<DevFestActivity> favouriteActivityMapper(QuerySnapshot snapshot, List<dynamic> favourites) {
    List<DevFestActivity> activities = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];
      var parsedActivity = activityParser(document);

      if (favourites.contains(parsedActivity.id)) {
        activities.add(parsedActivity);
      }
    }
    return activities;
  }

  static List<DevFestActivity> activityMapper(QuerySnapshot snapshot) {
    List<DevFestActivity> activities = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];
      activities.add(activityParser(document));

    }

    return activities;
  }

  static DevFestActivity activityParser(DocumentSnapshot document){
    if (document["type"] == "generic") {
      // Build new generic
      return DevFestActivity.generic(
          document["id"],
          document["type"],
          document["title"],
          document["desc"],
          document["cover"],
          document["location"],
          document["day"],
          document["start"],
          document["end"], "");
    } else if(document["type"] == "talk"){
      // Build new talk/workshop
      return DevFestActivity(
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
          document["abstract"]);
    }else{
      return DevFestActivity(
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
          document["abstract"]);
    }
  }
}
