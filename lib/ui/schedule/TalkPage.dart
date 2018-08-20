
import 'package:devfest_levante_2018/model/DevFestActivity.dart';
import 'package:devfest_levante_2018/model/DevFestSpeaker.dart';
import 'package:devfest_levante_2018/model/DevFestUser.dart';
import 'package:devfest_levante_2018/repository/SpeakersRepository.dart';
import 'package:devfest_levante_2018/repository/UserRepository.dart';
import 'package:devfest_levante_2018/utils/DateTimeHelper.dart';
import 'package:devfest_levante_2018/utils/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

String speakerName = "";
class TalkPage extends StatelessWidget {
  final DevFestActivity talk;
  final String userUid;

  TalkPage(this.talk, this.userUid);

  UserRepository userRepo;
  share(){

      String speakerString = "";
      if (speakerName != "") {
        speakerString = "con $speakerName";
      }
      Share.share('${talk.title} $speakerString alla #DevFestLev18');

  }

  @override
  Widget build(BuildContext context) {
    userRepo = UserRepository(userUid);
    speakerName = "";
    return Scaffold(
        body: SingleChildScrollView(child: ActivityChipWidget(talk)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.share,), onPressed: share),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder(
          stream: userRepo.getUser(),
          builder: (context, data) {
            if (data.hasData) {
              DevFestUser devFestUser = data.data;
              var bookmarks;
              bookmarks = devFestUser.bookmarks;

              if (bookmarks == null) {
                bookmarks = List<String>();
              }

              if (bookmarks.contains(talk.id)) {
                return BookmarkWidget(userRepo, talk, devFestUser, true);
              } else {
                return BookmarkWidget(userRepo, talk, devFestUser, false);
              }
            } else {
              return LoadingWidget();
            }
          }),

    );
  }
}

class BookmarkWidget extends StatefulWidget {
  DevFestActivity talk;
  UserRepository userRepo;
  DevFestUser user;
  bool isBookmark;

  BookmarkWidget(this.userRepo, this.talk, this.user, this.isBookmark);

  @override
  _BookmarkWidgetState createState() => _BookmarkWidgetState(this.userRepo, this.talk, this.user, this.isBookmark);
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  UserRepository userRepo;
  DevFestActivity talk;
  DevFestUser user;
  bool isBookmark;

  _BookmarkWidgetState(this.userRepo, this.talk, this.user, this.isBookmark);

  @override
  Widget build(BuildContext context) {
    if (isBookmark) {
      return FloatingActionButton(
        onPressed: () {
        _bookmark(userRepo, talk, false);
        setState(() {
          isBookmark = false;
        });
        },
      child: Icon(Icons.favorite),);
    } else {
      return FloatingActionButton(
        onPressed: () {
        _bookmark(userRepo, talk, true);
        setState(() {
          isBookmark = true;
        });
        },
        child: Icon(Icons.favorite_border),);    }
  }
}


class TalkCoverWidget extends StatelessWidget {
  DevFestActivity activity;

  TalkCoverWidget(this.activity);

  @override
  Widget build(BuildContext context) {
    if (activity.cover != null) {
      return FadeInImage.assetNetwork(
          fit: BoxFit.fitWidth,
          placeholder: 'assets/talk_generic.jpg',
          image: activity.cover);
    } else {
      return Image(
        fit: BoxFit.fitWidth,
        image: AssetImage('assets/talk_generic.jpg'),
      );
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
              Hero(
                tag: "anim_activity_${activity.id}",
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    activity.title,
                    textScaleFactor: 2.0,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                DateTimeHelper.formatTalkDateTimeStart(activity.start) + " - "+ DateTimeHelper.formatTalkTimeEnd(activity.end),
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
    if (activity.type != "activity") {
      return StreamBuilder(
        stream: SpeakersRepository.getSpeaker(activity.speakers),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          DevFestSpeaker speaker = snapshot.data;
          if (!snapshot.hasData) return Container();
          speakerName = speaker.name;
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
                  Hero(
                    tag: "anim_speaker_avatar_${activity.id}",
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(speaker.pic),
                      minRadius: 35.0,
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          speaker.company != "" ? speaker.name+", "+speaker.company : speaker.name,
                          textScaleFactor: 1.5,
                          style: TextStyle(fontWeight: FontWeight.w500),

                        ),

                        SizedBox(
                          height: 8.0,
                        ),
                        CommunityChip(speaker),
                      ],
                    ),
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
                height: 64.0,
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
            backgroundColor: getCommunityColor(speaker.type),
          )
        : Container());
  }
}

_bookmark(UserRepository userRepo, DevFestActivity talk, bool willAdd) {
  if (willAdd) {
    userRepo.addBookmark(talk.id);
  } else {
    userRepo.removeBookmark(talk.id);
  }
}

Color getCommunityColor(String type){
  if(type == "GDG"){
    return Colors.orange;
  }else if(type == "GDE"){
    return Colors.red;
  }
  else{
    return Colors.deepPurpleAccent;
  }
}

