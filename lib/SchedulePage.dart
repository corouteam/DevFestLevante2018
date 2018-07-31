import 'package:devfest_levante/DevFestActivity.dart';
import 'package:devfest_levante/TalkPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: new ListView.builder(
              itemCount: snapshot.data.documents.length,
              padding: const EdgeInsets.only(top: 10.0),
              itemBuilder: (context, index) =>
                  _buildListItem(context, activities[index]),
            ),
          );
        });
  }

  _buildListItem(BuildContext context, activity) {
    return ActivityTile(activity);
  }
}

class ActivityTile extends StatelessWidget {
  const ActivityTile(this.activity);

  final DevFestActivity activity;

  @override
  Widget build(BuildContext context) {
    return ListTile(

        // Show TIME at start
        leading: Column(
          // Allign all at start
          crossAxisAlignment: CrossAxisAlignment.start,
          // Will have 2 child (start time, end time)
          children: <Widget>[
            Text(
              formatTime(activity.start),
              style: TextStyle(color: Colors.indigoAccent),
              textScaleFactor: 1.5,
            ),
            Text(formatTime(activity.end))
          ],
        ),

        // Show activity Title
        title: Text(
          activity.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // Show activity description
        // Check if null first, some activities doesn't have description
        // For example talks have abstracts and don't feature a description
        subtitle: (activity.desc != null) ? Text(activity.desc) : null,

        // Finally show bookmark button at end

        // TODO: Add a GestureDetector with stateful Icon bookmark widget
        trailing: ActivityChipBuilder(activity.type),

        // On Click listener
        onTap: () => _openTalkPage(context, activity));
  }

  _openTalkPage(BuildContext context, DevFestActivity talk) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TalkPage(talk)));
  }

  String formatTime(DateTime dateTime) {
    final dateFormat = new DateFormat('HH:mm');

    return dateFormat.format(dateTime);
  }
}

class ActivityChipBuilder extends StatelessWidget {
  final String type;

  const ActivityChipBuilder(this.type)

  @override
  Widget build(BuildContext context) {
    if (type == "talk") {
      return Chip(
        backgroundColor: Colors.blueAccent,
        label: Text("TALK",
          style: TextStyle(color: Colors.white),),
      );
    } if (type == "workshop") {
      return Chip(
        backgroundColor: Colors.deepOrangeAccent,
        label: Text("WORKSHOP",
          style: TextStyle(color: Colors.white),),
      );
    } else {
      return Text("");
    }
  }
}