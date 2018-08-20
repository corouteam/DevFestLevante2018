import 'package:devfest_levante_2018/repository/ActivitiesRepository.dart';
import 'package:devfest_levante_2018/model/DevFestActivity.dart';
import 'package:devfest_levante_2018/model/DevFestSpeaker.dart';
import 'package:devfest_levante_2018/repository/SpeakersRepository.dart';
import 'package:devfest_levante_2018/ui/schedule/TalkPage.dart';
import 'package:devfest_levante_2018/utils/ColorUtils.dart';
import 'package:devfest_levante_2018/utils/DateTimeHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleSchedulePage extends StatefulWidget{
  SingleSchedulePageState createState() => SingleSchedulePageState(day);
  final int day;
  const SingleSchedulePage(this.day);

}

class SingleSchedulePageState extends State<SingleSchedulePage> {
  int day;
  SingleSchedulePageState(this.day);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ActivitiesRepository.getActivitiesByDay(day),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

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
    return InkWell(
      onTap: () => _openTalkPage(context, activity),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StartTimeWidget(activity),
                ActivityChipWidget(activity),
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TitleWidget(activity),
                    DescriptionWidget(activity),
                    SpeakerChipWidget(activity),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openTalkPage(BuildContext context, DevFestActivity talk) {

    FirebaseAuth.instance.currentUser().then((user) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TalkPage(talk, user.uid)));
    });
  }
}

class SpeakerChipWidget extends GenericScheduleWidget {
  SpeakerChipWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    // Only shows my avatar for now \o/
    // Even if this is really cool, we need to join talk with speakers. Later.
    // TODO query Firestore with speakerID

    if (activity.type != "activity") {
      return StreamBuilder(
        stream: SpeakersRepository.getSpeaker(activity.speakers),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          DevFestSpeaker speaker = snapshot.data;
          if (!snapshot.hasData) return Container();

          return Chip(
            backgroundColor: Colors.white,
            label: Text(speaker.name),
            avatar: Hero(
                tag: "anim_speaker_avatar_${activity.id}",
                child: CircleAvatar(backgroundImage: NetworkImage(speaker.pic))),
          );
        },
      );
    } else {
      return Container();
    }
  }
}

class TitleWidget extends GenericScheduleWidget {
  TitleWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "anim_activity_${activity.id}",
      child: Material(
        color: Colors.transparent,
        child: Text(
          activity.title,
          textScaleFactor: 1.4,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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

class StartTimeWidget extends GenericScheduleWidget {
  StartTimeWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    var color = ColorUtils.hexToColor("#676767");

    if (activity.type == "talk") {
      color = Colors.blueAccent;
    } else if (activity.type == "workshop") {
      color = Colors.deepOrangeAccent;
    }

    return Text(DateTimeHelper.formatTime(activity.start),
        textScaleFactor: 1.8,
        style: TextStyle(color: color, fontWeight: FontWeight.w300));
  }
}

class ActivityChipWidget extends GenericScheduleWidget {
  ActivityChipWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    if (activity.type == "talk") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              "TALK",
              style: TextStyle(
                  color: ColorUtils.hexToColor("#676767"), fontWeight: FontWeight.w300),
              textScaleFactor: 0.8,
            ),
          ),
        ],
      );
    }
    if (activity.type == "workshop") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              "WORKSHOP",
              style: TextStyle(
                  color: ColorUtils.hexToColor("#676767"), fontWeight: FontWeight.w300),
              textScaleFactor: 0.7,
            ),
          ),
        ],
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
