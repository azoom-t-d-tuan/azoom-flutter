import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckTimeState extends State<CheckTime> {
  static final now = DateTime.now();
  String today = DateFormat("dd-MM-yyyy").format(now);
  var _isCheckin = false;
  var _checkinTime = 'Checkin';
  var _isCheckout = false;
  var _checkoutTime = 'Checkout';
  var _memoController = TextEditingController();
  var _id = DateFormat('yyyyMMdd').format(DateTime.now());

  @override
  initState() {
    super.initState();
    getData(widget.checktime['id']);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextFormField _txtMemo = new TextFormField(
      controller: _memoController,
      decoration: InputDecoration(
        hintText: 'Enter your memo',
        contentPadding: EdgeInsets.all(20.0),
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
    );
    return Scaffold(
        appBar: AppBar(title: Text('Checktime')),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
                  child: Text(
                    this.today,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.blue),
                  ),
                )),
            Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(_checkinTime),
                              onPressed: _isCheckin
                                  ? null
                                  : () {
                                      setState(() {
                                        _checkinTime = DateFormat("hh:mm")
                                            .format(DateTime.now());
                                        _isCheckin = true;
                                      });
                                      var _newRecord = {
                                        _id: {'checkin': _checkinTime}
                                      };
                                      Firestore.instance
                                          .collection('users')
                                          .document(widget.checktime['id'])
                                          .setData({'checktime': _newRecord},
                                              merge: true);
                                    })),
                      Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Expanded(
                          child: RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(_checkoutTime),
                              onPressed: _isCheckout
                                  ? null
                                  : () {
                                      setState(() {
                                        _checkoutTime = DateFormat("hh:mm")
                                            .format(DateTime.now());
                                        _isCheckout = true;
                                      });
                                      var _newRecord = {
                                        _id: {'checkout': _checkoutTime}
                                      };
                                      Firestore.instance
                                          .collection('users')
                                          .document(widget.checktime['id'])
                                          .setData({'checktime': _newRecord},
                                              merge: true);
                                    }))
                    ])),
            Container(
                margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    border: Border.all(width: 1.2, color: Colors.black12),
                    borderRadius: BorderRadius.all(const Radius.circular(4.0))),
                child: _txtMemo),
            Container(
              margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  var _newRecord = {
                    _id: {'memo': _memoController.text}
                  };
                  Firestore.instance
                      .collection('users')
                      .document(widget.checktime['id'])
                      .setData({'checktime': _newRecord}, merge: true);
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }

  getData(email) async {
    var userInfo;
    await Firestore.instance
        .collection('users')
        .document(email)
        .get()
        .then((ds) {
      userInfo = ds.data;
    });
    setState(() {
      if (userInfo['checktime'][_id]['checkout'] != null) {
        _checkoutTime = userInfo['checktime'][_id]['checkout'];
        _isCheckout = true;
      }
      if (userInfo['checktime'][_id]['checkin'] != null) {
        _checkinTime = userInfo['checktime'][_id]['checkin'];
        _isCheckin = true;
      }
      if (userInfo['checktime'][_id]['memo'] != null) {
        _memoController.text = userInfo['checktime'][_id]['memo'];
      }
    });
  }
}

class CheckTime extends StatefulWidget {
  final checktime;
  CheckTime(this.checktime);
  @override
  CheckTimeState createState() => CheckTimeState();
}
