import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final checktime;
  final String job;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        job = map['job'],
        checktime = map['checktime'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$name:$checktime>";
}
