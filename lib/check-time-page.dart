import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/user.dart';

class CheckTimeState extends State<CheckTime> {
  static final now = DateTime.now();
  String today = DateFormat("dd-MM-yyyy").format(now);
  var _memoController = TextEditingController();
  var _id = DateFormat('yyyyMMdd').format(DateTime.now());

  @override
  initState() {
    super.initState();
  }

  void _showcontent() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Success'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Memo has been saved!'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Checktime')), body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(widget.checktime['id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildListItem(context, snapshot.data);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = User.fromSnapshot(data);
    _memoController.text =
        (record.checktime[_id] != null && record.checktime[_id]['memo'] != null)
            ? record.checktime[_id]['memo']
            : '';
    bool _isCheckin = (record.checktime[_id] != null &&
        record.checktime[_id]['checkin'] != null);
    bool _isCheckout = (record.checktime[_id] != null &&
        record.checktime[_id]['checkout'] != null);
    return Column(
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
                          child: Text(_isCheckin
                              ? record.checktime[_id]['checkin']
                              : 'Checkin'),
                          onPressed: _isCheckin
                              ? null
                              : () {
                                  var _newRecord = {
                                    _id: {
                                      'checkin': DateFormat("hh:mm")
                                          .format(DateTime.now())
                                    }
                                  };
                                  record.reference.setData(
                                      {'checktime': _newRecord},
                                      merge: true);
                                })),
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  Expanded(
                      child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text(_isCheckout
                              ? record.checktime[_id]['checkout']
                              : 'Checkout'),
                          onPressed: _isCheckout
                              ? null
                              : () {
                                  var _newRecord = {
                                    _id: {
                                      'checkout': DateFormat("hh:mm")
                                          .format(DateTime.now())
                                    }
                                  };
                                  record.reference.setData(
                                      {'checktime': _newRecord},
                                      merge: true);
                                }))
                ])),
        Container(
            margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
                border: Border.all(width: 1.2, color: Colors.black12),
                borderRadius: BorderRadius.all(const Radius.circular(4.0))),
            child: TextFormField(
              controller: _memoController,
              decoration: InputDecoration(
                hintText: 'Enter your memo',
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
            )),
        Container(
          margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
          child: MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              var _newRecord = {
                _id: {'memo': _memoController.text}
              };
              record.reference.setData({'checktime': _newRecord}, merge: true);
              Navigator.pop(context);
              _showcontent();
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

class CheckTime extends StatefulWidget {
  final checktime;
  CheckTime(this.checktime);
  @override
  CheckTimeState createState() => CheckTimeState();
}
