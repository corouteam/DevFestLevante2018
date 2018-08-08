import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante/DevFestFaq.dart';
import 'package:devfest_levante/DevFestSpeaker.dart';

class FaqRepository {
  static Stream<List<DevFestFaq>> getFaqs() {
    return Firestore.instance
        .collection('faq')
        .snapshots()
        .map((snapshot) => (_parseFaq(snapshot)));
  }

  static List<DevFestFaq> _parseFaq(QuerySnapshot snapshot) {
    List<DevFestFaq> faqs = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];
      faqs.add(DevFestFaq(document["title"], document["text"]));
    }

    return faqs;
  }
}
