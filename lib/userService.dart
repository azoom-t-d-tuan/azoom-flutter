import 'package:cloud_firestore/cloud_firestore.dart';

getData(email) async {
    var userInfo;
    await Firestore.instance
        .collection('users')
        .document(email)
        .get()
        .then((ds) {
      userInfo = ds.data;
    });
    return userInfo;
}
