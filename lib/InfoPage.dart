import 'package:devfest_levante/DevFestFaq.dart';
import 'package:devfest_levante/DevFestTabTextTheme.dart';
import 'package:devfest_levante/FaqRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: <Widget>[
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(child: DevFestTabTextTheme("FAQ")),
            ],
          ),
          Expanded(child: TabBarView(children: <Widget>[FaqPage()])),
        ],
      ),
    );
  }
}

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FaqRepository.getFaqs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(child: Center(child: Text("Loading...")));

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

  _buildListItem(BuildContext context, data) {
    DevFestFaq faq = data;

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
