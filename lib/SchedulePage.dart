import 'package:devfest_levante/ActivitiesRepository.dart';
import 'package:devfest_levante/DevFestActivity.dart';
import 'package:devfest_levante/TalkPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  final int day;

  const SchedulePage(this.day);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ActivitiesRepository.getActivitiesByDay(day),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');

          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: new ListView.builder(
              itemCount: snapshot.data.length,
              padding: const EdgeInsets.only(top: 10.0),
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data[index]),
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
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          // Will have 2 child (start time, end time),
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
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // If we have no description, return just an empty view
              // TALKs and WORKSHOP have NO description! They will have speaker chip instead
              ((activity.desc != null) ? Text(activity.desc) : Container()),

              // Append speaker chip below if not generic activity
              SpeakerChipBuilder("talk")
            ]),

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

class SpeakerChipBuilder extends StatelessWidget {
  final String speakerId;

  const SpeakerChipBuilder(this.speakerId);

  @override
  Widget build(BuildContext context) {
    // TODO query Firestore with speakerID
    return Chip(
      backgroundColor: Colors.white,
      label: Text("Paolo Rotolo"),
      avatar: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://scontent-mxp1-1.xx.fbcdn.net/v/t31.0-8/22770548_1581115798592916_7792073047443004744_o.jpg?_nc_cat=0&oh=43f97db7ead550d25118f0ff92fe3596&oe=5BC71863"),
      ),
    );
  }
}

class ActivityChipBuilder extends StatelessWidget {
  final String type;

  const ActivityChipBuilder(this.type);

  @override
  Widget build(BuildContext context) {
    if (type == "talk") {
      return Chip(
        backgroundColor: Colors.blueAccent,
        label: Text(
          "TALK",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (type == "workshop") {
      return Chip(
        backgroundColor: Colors.deepOrangeAccent,
        label: Text(
          "WORKSHOP",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return Text("");
    }
  }
}
