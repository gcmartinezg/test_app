import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/domains/record.dart';
import 'package:test_firebase/pages/baby_details_page.dart';
import 'package:test_firebase/services/authentication.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  HomePage({Key key, this.auth, this.userId, this.logoutCallback}): super(key: key);
 
 @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<HomePage> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Baby Name Votes'),
       actions: <Widget>[
          new FlatButton(
            child: new Text(
              'Logout',
              style: new TextStyle(fontSize: 17.0, color: Colors.white)
            ),
            onPressed: signOut)
          ],
       ),
     body: _buildBody(context),
   );
 }

 	
  /*_dismissDialog() {
    Navigator.pop(context);
  }*/

 /*void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Baby'),
            content: Text('Enter the baby\'s name'),
            actions: <Widget>[
              TextFormField(
                decoration: new InputDecoration(
                  hintText: 'Name',
                ),
              ),
              FlatButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text('Close')),
              FlatButton(
                onPressed: () {
                  print('Add');
                  _dismissDialog();
                },
                child: Text('HelloWorld!'),
              )
            ],
          );
        });
  }*/

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
      
    } catch (e) {
      print(e);
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () => record.reference.updateData({'votes': record.votes + 1}),
          onLongPress: () => _showDetails(record),
        ),
      ),
    );
  }

  _showDetails(Record record){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BabyDetails(
          auth: widget.auth, 
          userId: widget.userId, 
          selectedBaby: record
        )
      )
    );
  }

  /*_showDetails(Record record){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(record.name + ' Information'),
          content: ListView(
            children: <Widget>[
              _buildHeader(record),
              _buildInformation(record),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _dismissDialog();
              },
                child: Text('Close')
            )
          ],
        );
      }
    );
  }

  _buildHeader(Record record){
    return Container(
      //decoration: BoxDecoration(color: Colors.blue),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.30,
      child: Column(
        children: <Widget>[
          Image.network(record.ppUrl,height: 100,width: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  child: Text(
                    record.name + ' ' + record.lastName,
                    style: TextStyle(color: Colors.black),
                  ),
                  fit: BoxFit.fitWidth,
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildInformation(Record record){
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text(
                record.name,
                overflow: TextOverflow.clip,
              ),
              subtitle: Text('Name'),
            ),
          ),
          Card(
            child: ListTile(
              //TODO cambiar iconos
              title: Text(
                record.lastName,
                overflow: TextOverflow.clip,
              ),
              subtitle: Text('Last Name'),
            ),
          )
        ],
      )
    );
  }*/

}