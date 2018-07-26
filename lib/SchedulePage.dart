import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('talks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          for (int i = 0; i < snapshot.data.documents.length; i++){
              return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                //   itemExtent: 100.0,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),

              );

          }

        }
    );
  }

  _buildListItem(BuildContext context, document) {
    return TalkTile(document);
  }
}

class TalkTile extends StatelessWidget {

  final DocumentSnapshot document;

  const TalkTile(this.document);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: new GestureDetector(
        onTap: () =>
        showDialog(context: context,
        builder: (context) => _dialogBuilder(context, document['Title'], document['Bio'],
        document['Abstract'], document['Speaker'])),
        child: Container(
          decoration: new BoxDecoration(
              border: new Border(bottom: new BorderSide(
                color: Colors.grey,
              ))
          ),
          child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Row(
              children: <Widget>[

                new Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: <Widget>[
                      Text(document['Title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),

                      ),
                      new Container(
                        child: new Row(
                          children: <Widget>[
                            Text(document['Speaker'],
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16.0),
                              decoration: new BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),

                              ),
                              child: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(document['Community'],

                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0
                                  ),),
                              ),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.favorite),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogBuilder(BuildContext context, String title, String abstract, String bio,
      String speaker) {
    return SimpleDialog(
      children: <Widget>[Container(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            Text(title,
            style: Theme.of(context).textTheme.title,),
            new Container(
              decoration: BoxDecoration(
                border: Border( bottom: BorderSide(
                  color: Theme.of(context).accentColor,
                ))
              ),
              padding: const EdgeInsets.only(top: 16.0),
              child: new Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(abstract,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 32.0),
              child: Text(speaker,
              style: Theme.of(context).textTheme.title,
                    ),
            ),
            SizedBox(height: 16.0),
            Text(abstract),
  ],

        ),
      ),

    )],
    contentPadding: EdgeInsets.all(8.0),);
  }
}