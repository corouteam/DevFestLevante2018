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
/*

  Elements that can be generated:

  TitleWidget(activity)
  Show activity title;
  Argument must not be null;

  DescriptionWidget(activity)
  Show activity description. Returns an empty container if description is null;


  StartTimeWidget(activity)
  Show activity's start time.
  Argument must not be null;

  SpeakerChipWidget(activity)
  Show a chip with Speaker's avatar and name.
  Returns an empty container if activity doesn't have a speaker (generic activity);

  ActivityChipWidget(activity)
  Show a chip with Activity type (Talk|Workshop)
  Returns an empty container in case of generic activity;


*/

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: StartTimeWidget(activity)),
                ActivityChipWidget(activity)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TitleWidget(activity),
                DescriptionWidget(activity)
              ],
            ),
            SpeakerChipWidget(activity)
          ],
        ),
      ),
    );
  }

  _openTalkPage(BuildContext context, DevFestActivity talk) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TalkPage(talk)));
  }
}

class TitleWidget extends GenericScheduleWidget {
  TitleWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return Text(
      activity.title,
      textScaleFactor: 1.5,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class DescriptionWidget extends GenericScheduleWidget {
  DescriptionWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return ((activity.desc != null) ? Text(activity.desc) : Container());
  }
}

class StartTimeWidget extends StatelessWidget {
  final DevFestActivity activity;

  StartTimeWidget(this.activity);

  @override
  Widget build(BuildContext context) {
    return Text(formatTime(activity.start),
        textScaleFactor: 1.2, style: TextStyle(color: Colors.blueAccent));
  }
}

class SpeakerChipWidget extends GenericScheduleWidget {
  SpeakerChipWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    // TODO query Firestore with speakerID

    if (activity.type != "activity") {
      return Chip(
        backgroundColor: Colors.white,
        label: Text("Paolo Rotolo"),
        avatar: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://scontent-mxp1-1.xx.fbcdn.net/v/t31.0-8/22770548_1581115798592916_7792073047443004744_o.jpg?_nc_cat=0&oh=43f97db7ead550d25118f0ff92fe3596&oe=5BC71863"),
        ),
      );
    } else {
      return Container();
    }
  }
}

class ActivityChipWidget extends GenericScheduleWidget {
  ActivityChipWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    if (activity.type == "talk") {
      return Transform(
        transform: new Matrix4.identity()..scale(0.8),
        child: Chip(
          backgroundColor: Colors.blueAccent,
          label: Text(
            "TALK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    if (activity.type == "workshop") {
      return Transform(
        transform: new Matrix4.identity()..scale(0.8),
        child: Chip(
          backgroundColor: Colors.deepOrangeAccent,
          label: Text(
            "WORKSHOP",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return Text("");
    }
  }
}

abstract class GenericScheduleWidget extends StatelessWidget {
  final DevFestActivity activity;
  const GenericScheduleWidget(this.activity);
}

String formatTime(DateTime dateTime) {
  final dateFormat = new DateFormat('HH:mm');

  return dateFormat.format(dateTime);
}
