import 'package:devfest_levante_2018/model/DevFestFaq.dart';
import 'package:devfest_levante_2018/repository/FaqRepository.dart';
import 'package:devfest_levante_2018/utils/UrlHelper.dart';
import 'package:devfest_levante_2018/utils/LoadingWidget.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FaqRepository.getFaqs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return LoadingWidget();

          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: new ListView.builder(
              // Count Tournament header as item
              itemCount: snapshot.data.length+1,
              padding: const EdgeInsets.only(top: 10.0),
              itemBuilder: (context, index) =>
              // Builder will build listview dynamically adding the
              // tournament header as first item
              // That's why we need to pass index too
                  _buildListItem(context, index, snapshot.data),
            ),
          );
        });
  }

  _buildListItem(BuildContext context, int index, data) {
    if (index==0) {
      return TournamentCard();
    } else {
      DevFestFaq faq = data[index-1];

      return ExpansionTile(
        title: Text(faq.title),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                faq.text,
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      );
    }
  }
}

class TournamentCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text("Pronto per i tornei?", style: TextStyle(color: Colors.white), textScaleFactor: 1.5,),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Scarica subito l'app Enjore per partecipare ai tornei sportivi della DevFest Levante 2018", style: TextStyle(color: Colors.white),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: <Widget>[
                      InkResponse(
                        onTap: () => UrlHelper.launchURL("https://play.google.com/store/apps/details?id=com.enjore"),
                        child: Text("ANDROID", style: TextStyle(color: Colors.white)),),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: InkResponse(
                          onTap: () => UrlHelper.launchURL("https://itunes.apple.com/it/app/enjore/id778026431"),
                          child: Text("iOS", style: TextStyle(color: Colors.white)),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}