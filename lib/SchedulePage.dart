import 'package:devfest_levante/DevFestActivity.dart';
import 'package:devfest_levante/TalkPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('talks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');

          List<DevFestActivity> activities = [];

          for (int i = 0; i < snapshot.data.documents.length; i++) {
            DocumentSnapshot document = snapshot.data.documents[i];

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

          return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) =>
                _buildListItem(context, activities[index]),
          );
        });
  }

  _buildListItem(BuildContext context, activity) {
    return ActivityTile(activity);
  }
}

class ActivityTile extends StatelessWidget {
  final DevFestActivity activity;

  const ActivityTile(this.activity);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: new GestureDetector(
        // Build talk object
        onTap: () => _openTalkPage(context, activity),
        child: ,

      ),
    );
  }

  _openTalkPage(BuildContext context, DevFestActivity talk) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TalkPage(talk)));
  }
}
