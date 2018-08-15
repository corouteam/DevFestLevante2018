import 'package:devfest_levante/DevFestActivity.dart';
import 'package:flutter/material.dart';

class TalkPage extends StatelessWidget {
  final DevFestActivity talk;

  TalkPage(this.talk);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TalkCoverWidget(talk),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Titolo fantastico",
                      textScaleFactor: 1.8,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Tue 2, 10:30 AM - 12:20 PM",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Main stage",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 28.0,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras arcu erat, fermentum ac lacinia in, luctus at ante. Proin in magna porta, fermentum tortor a, porta orci. Aenean vehicula mattis euismod. Maecenas fermentum, tellus vel condimentum aliquet, massa tortor maximus orci, laoreet commodo risus nisi non dui. Nulla eu laoreet nisl. Nulla sollicitudin tincidunt velit eget blandit. Curabitur dignissim mauris eros, et facilisis nulla iaculis vel. Fusce dui sapien, vulputate ac dui et, blandit lacinia nulla. Cras at venenatis sem. Sed in metus id nulla lacinia ullamcorper. Fusce eget tortor quam. Aenean volutpat enim eget sapien tempus, vel efficitur nisl tincidunt. Aenean at feugiat velit. Quisque non porttitor arcu, vitae pellentesque dolor. Donec nisi mauris, venenatis sit amet pharetra at, placerat a arcu.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                            backgroundImage: NetworkImage(
                                "http://devfestlevante.eu/img/people/rigo.jpg"),
                        minRadius: 35.0,),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text("Nome speaker",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras arcu erat, fermentum ac lacinia in, luctus at ante. Proin in magna porta, fermentum tortor a, porta orci. Aenean vehicula mattis euismod.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class TalkCoverWidget extends StatelessWidget {
  DevFestActivity activity;

  TalkCoverWidget(this.activity);

  @override
  Widget build(BuildContext context) {
    if (activity.cover != null) {
      return Image(
        fit: BoxFit.fitWidth,
        image: NetworkImage(activity.cover),
        height: 150.0,
      );
    } else {
      return Container();
    }
  }


}