import 'package:devfest_levante/DevFestActivity.dart';
import 'package:devfest_levante/DevFestSpeaker.dart';
import 'package:devfest_levante/SpeakersRepository.dart';
import 'package:flutter/material.dart';

class TalkPage extends StatelessWidget {
  final DevFestActivity talk;

  TalkPage(this.talk);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(child: ActivityChipWidget(talk)),
      bottomNavigationBar: BottomAppBar(),
      floatingActionButton: FloatingActionButton(onPressed: null),
    );
  }
}

class TalkCoverWidget extends StatelessWidget {
  DevFestActivity activity;

  TalkCoverWidget(this.activity);

  @override
  Widget build(BuildContext context) {
    if (activity.cover != null) {
      return Image(
        fit: BoxFit.fill,
        image: NetworkImage(activity.cover),
        height: 200.0,
      );
    } else {
      return Container();
    }
  }
}

abstract class GenericScheduleWidget extends StatelessWidget {
  final DevFestActivity activity;
  const GenericScheduleWidget(this.activity);
}

class ActivityChipWidget extends GenericScheduleWidget {
  ActivityChipWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            TalkCoverWidget(activity),
            SafeArea(
                child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white70,
              ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                activity.title,
                textScaleFactor: 2.0,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Tue 2, 10:30 AM - 12:20 PM",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                activity.location,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 28.0,
              ),
              AbstractWidget(activity),
              DescriptionWidget(activity),
              SizedBox(
                height: 48.0,
              ),
              SpeakerChipWidget(activity),
            ],
          ),
        ),
      ],
    );
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " SPEAKER",
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(speaker.pic),
                    minRadius: 35.0,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        speaker.name,
                        textScaleFactor: 1.5,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      CommunityChip(speaker),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                speaker.bio,
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 32.0,
              ),
            ],
          );
        },
      );
    } else {
      return Container();
    }
  }
}

class DescriptionWidget extends GenericScheduleWidget {
  DescriptionWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return ((activity.desc != null)
        ? Text(
            activity.desc,
            textAlign: TextAlign.justify,
          )
        : Container());
  }
}

class AbstractWidget extends GenericScheduleWidget {
  AbstractWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return ((activity.abstract != null)
        ? Text(
            activity.abstract,
            textAlign: TextAlign.justify,
          )
        : Container());
  }
}

class CommunityChip extends StatelessWidget {
  DevFestSpeaker speaker;
  CommunityChip(this.speaker);

  @override
  Widget build(BuildContext context) {
    return ((speaker.community != "")
        ? Chip(
            label: Text(
              speaker.community,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          )
        : Container());
  }
}

bookmark() {
  print("bookmark");
}
