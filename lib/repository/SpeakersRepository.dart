import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante_2018/model/DevFestSpeaker.dart';

class SpeakersRepository {
  static Stream<DevFestSpeaker> getSpeaker(String id) {
    return Firestore.instance
        .collection('speakers')
        .where("id", isEqualTo: id)
        .snapshots()
        .map((snapshot) => (parseSpeaker(snapshot)));
  }

  static DevFestSpeaker parseSpeaker(QuerySnapshot snapshot) {
    var document = snapshot.documents.first;

    return DevFestSpeaker(
        document["id"],
        document["bio"],
        document["community"],
        document["company"],
        document["name"],
        document["pic"],
        document["type"]);
  }
}
