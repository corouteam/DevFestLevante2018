import 'package:devfest_levante_2018/model/DevFestFaq.dart';
import 'package:devfest_levante_2018/repository/FaqRepository.dart';
import 'package:devfest_levante_2018/utils/DevFestTabTextTheme.dart';
import 'package:devfest_levante_2018/utils/UrlHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';


import 'package:latlong/latlong.dart';class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            isScrollable: false,
            tabs: [
              Tab(child: DevFestTabTextTheme("FAQ")),
              Tab(child: DevFestTabTextTheme("Come raggiungerci")),
            ],
          ),
          Expanded(child: TabBarView(children: <Widget>[FaqPage(), MapPage()])),
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

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text("Dagli aeroporti", textScaleFactor: 1.5),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("La società di autobus SITA SUD effettua la tratta aeroporto di Brindisi - Lecce Foro Boario (Stazione degli autobus). La tariffa è di 6,50€."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: MaterialButton(
                          onPressed: () => UrlHelper.launchURL("http://www.sitasudtrasporti.it/archivio/Download/corse/sitasud/Puglia/Bari/85a4f897-3517-423f-ae88-33ea7b7342ae_ORBA793-18A.pdf/0"),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text("Scarica orari"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text("Trasporti pubblici", textScaleFactor: 1.5,),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("La società di autobus COTRAP con l'autobus 101 effettua la tratta Lecce Foro Boario (Stazione degli autobus) - Lecce Stazione dei treni - Torre Dell'Orso. Si scende all'Hotel Thalas vicino al Village Camping Sentinella."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: MaterialButton(
                          onPressed: () => UrlHelper.launchURL("http://www.provincia.le.it/documents/10716/edbbec03-63a3-4a23-933a-9f922dd1d9db"),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text("Scarica orari"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text("Village Camping Sentinella"),
                subtitle: Text("Via Degli Eucaliptus, Torre Dell'Orso"),
                ),
              ),
            ),
          ),
        Container(
          height: 300.0,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(40.273107, 18.418159),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(40.273107, 18.418159),
                    builder: (ctx) => Container(
                      child: Icon(Icons.assistant_photo, color: Colors.deepOrange,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

}
