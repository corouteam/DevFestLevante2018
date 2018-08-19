import 'package:devfest_levante_2018/utils/UrlHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => UrlHelper.launchURL("https://www.google.it/maps/place/Village+Camping+Sentinella/@40.273107,18.4159703,17z/data=!3m1!4b1!4m7!3m6!1s0x134437f998eb0623:0x59976d012b4b91d0!5m1!1s2018-09-02!8m2!3d40.273107!4d18.418159"),
            child: Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Village Camping Sentinella", style: TextStyle(color: Colors.white), textScaleFactor: 1.5,),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Via Degli Eucaliptus, Torre Dell'Orso", style: TextStyle(color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Text("APRI IN MAPS", style: TextStyle(color: Colors.white),),
                      ),
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
                title: Text("Dagli aeroporti", textScaleFactor: 1.5),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                          "La società di autobus SITA SUD effettua la tratta aeroporto di Brindisi - Lecce Foro Boario (Stazione degli autobus). La tariffa è di 6,50€."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: MaterialButton(
                          onPressed: () =>
                              UrlHelper.launchURL(
                                  "http://www.sitasudtrasporti.it/archivio/Download/corse/sitasud/Puglia/Bari/85a4f897-3517-423f-ae88-33ea7b7342ae_ORBA793-18A.pdf/0"),
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
                      Text(
                          "La società di autobus COTRAP con l'autobus 101 effettua la tratta Lecce Foro Boario (Stazione degli autobus) - Lecce Stazione dei treni - Torre Dell'Orso. Si scende all'Hotel Thalas vicino al Village Camping Sentinella."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: MaterialButton(
                          onPressed: () =>
                              UrlHelper.launchURL(
                                  "http://www.provincia.le.it/documents/10716/edbbec03-63a3-4a23-933a-9f922dd1d9db"),
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
                    builder: (ctx) =>
                        Container(
                          child: Icon(
                            Icons.assistant_photo, color: Colors.deepOrange,),
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