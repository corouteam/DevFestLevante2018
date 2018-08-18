import 'package:devfest_levante_2018/utils/UrlHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Center(child: Text("DevFest Levante 2018 Official App", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)),
          Center(child: Text("Version 1.0.0")),
          Padding(
            padding: const EdgeInsets.only(top:16.0),
            child: Center(child: Text("Made with ♥ in Flutter by")),
          ),
          Center(child: Text("2 Coffees 1 Tea(m)", style: TextStyle(fontSize: 20.0),)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: PersonWidget("The\nOpenSourcer", "http://devfestlevante.eu/img/people/paolo.jpg")),
                Expanded(child: PersonWidget("The\nMacBook Slayer", "http://devfestlevante.eu/img/people/labellarte.jpg")),
                Expanded(child: PersonWidget("The\n GIT worst\nNightmare", "http://devfestlevante.eu/img/people/lops.jpg")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              children: <Widget>[
                Text("with the help of some friends at"),
                Text("GDG Bari", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          ListTile(
            onTap: () => UrlHelper.launchURL("https://github.com/2coffees1team/DevFestLevante2018"),
            title: Text("Source Code", style: TextStyle(color: Colors.blueAccent),),
            subtitle: Text("Available on GitHub"),
          ),
          ListTile(
            onTap: () =>
                showLicensePage(
                    context: context,
                    applicationName: "DevFest Levante 2018",
                    applicationVersion: "1.0.0",
                    applicationLegalese: "Copyright 2018 © 2 Coffees 1 Tea(m)"),
            title: Text("Open Source Licences", style: TextStyle(color: Colors.blueAccent),),
          ),
          ListTile(
            onTap: () => UrlHelper.launchURL("http://devfestlevante.eu"),
            title: Text("Official Website", style: TextStyle(color: Colors.blueAccent),),
          ),
          ListTile(
            onTap: () => UrlHelper.launchURL("https://www.facebook.com/GDGBari/"),
            title: Text("Contact us", style: TextStyle(color: Colors.blueAccent),),
          ),
        ],
      ),
    );
  }

  void showLicensePage({
    @required BuildContext context,
    String applicationName,
    String applicationVersion,
    Widget applicationIcon,
    String applicationLegalese
  }) {
    assert(context != null);
    Navigator.push(context, new MaterialPageRoute<void>(
        builder: (BuildContext context) => new LicensePage(
            applicationName: applicationName,
            applicationVersion: applicationVersion,
            applicationLegalese: applicationLegalese
        )
    ));
  }
}

class PersonWidget extends StatelessWidget {
  final String url;
  final String desc;

  const PersonWidget(this.desc, this.url);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        CircleAvatar(
            backgroundImage: NetworkImage(url),
        radius: 40.0,),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(desc, textAlign: TextAlign.center),
        ),
      ],
    );
  }

}