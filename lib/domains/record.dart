import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
 final String name;
 final int votes;
 final String ppUrl;
 final String lastName;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['votes'] != null),
       assert(map['ppUrl'] != null),
       assert(map['lastName'] != null),
       name = map['name'],
       votes = map['votes'],
       ppUrl = map['ppUrl'],
       lastName = map['lastName'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$votes>";
}