import 'dart:io';
import 'package:path/path.dart' as Path;

import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_firebase/domains/record.dart';
import 'package:test_firebase/services/authentication.dart';

class BabyDetails extends StatefulWidget {
  final BaseAuth auth;
  final String userId;
  final Record selectedBaby;

  BabyDetails({
    Key key, this.auth, this.userId, 
    this.selectedBaby
  }) : super(key: key);

  @override
  _BabyDetailsState createState() => _BabyDetailsState();
}

class _BabyDetailsState extends State<BabyDetails> {
  File _image;
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedBaby.name} Information')
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context){
    return ListView(
      children: <Widget>[
        _buildHeader(widget.selectedBaby),
        _buildDetails(widget.selectedBaby)
      ],
    );
  }

  _buildHeader(Record record){
    return Container(
      //decoration: BoxDecoration(color: Colors.blue),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.30,
      child: Column(
        children: <Widget>[
          new RawMaterialButton(
            onPressed: () => _showUploadImageDialog(record),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                record.ppUrl, 
                //height: 200, 
                //width: 150 
              ),
              radius: 60.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(15.0),
            constraints: BoxConstraints(maxHeight: 130, maxWidth: 130),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  child: Text(
                    '${record.name} ${record.lastName}',
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

  _buildDetails(Record record){
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
  }

  _showUploadImageDialog(Record record){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload an Image...'),
          content: _buildDialogBody(record),
          /*actions: <Widget>[
            FlatButton(
              onPressed: () {
                _dismissDialog();
              },
              child: Text('Close')
            )
          ],*/
        );
      }
    );
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  _buildDialogBody(Record record){
    return Column(
      children: <Widget>[
        _image != null    
        ? Image.asset(    
          _image.path,    
          height: 150,    
        )    
        : Container(height: 150),
        _image == null    
        ? RaisedButton(    
          child: Text('Choose File'),    
          onPressed: chooseFile,    
          color: Colors.cyan,    
        )    
        : Container(),    
        _image != null    
        ? RaisedButton(    
          child: Text('Upload File'),    
          onPressed: () => uploadFile(record),    
          color: Colors.cyan,    
        )    
        : Container(),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery
    ).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile(Record record) async {
    StorageReference storageReference = FirebaseStorage.instance.ref()
      .child('${record.reference.documentID}/${Path.basename(_image.path)}}');
    
    StorageUploadTask uploadTask = storageReference.putFile(_image);    
    
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        record.reference.updateData({'ppUrl': _uploadedFileURL});
      });
    }).whenComplete(_dismissDialog());
  }

}