import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SabbaticalState extends State<Sabbatical> {
  var _dropdownValue = 'Phép năm';
  final _reasonController = TextEditingController();
  final _contactController = TextEditingController();
  final _optionController = TextEditingController();
  var _pickDate;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _reasonController.dispose();
    _contactController.dispose();
    _optionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đơn xin nghỉ phép')),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  child: Text('Ngày nghỉ:')),
              Container(
                  margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  child: MaterialButton(
                      color: Colors.lightBlue,
                      onPressed: () async {
                        final List<DateTime> picked2 =
                            await DateRangePicker.showDatePicker(
                                context: context,
                                initialFirstDate:
                                    DateTime.now().subtract(Duration(days: 1)),
                                initialLastDate: DateTime.now(),
                                firstDate: new DateTime(2015),
                                lastDate: new DateTime(2021));
                        if (picked2 != null) {
                          setState(() {
                            _pickDate = picked2
                                .map(
                                    (ob) => DateFormat("yyyy-MM-dd").format(ob))
                                .toString();
                          });
                        }
                      },
                      child: Text("Pick date",
                          style: TextStyle(color: Colors.white))))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  child: Text('Lựa chọn:')),
              Container(
                  margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  child: DropdownButton<String>(
                    value: _dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    isDense: true,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: <String>[
                      'Phép năm',
                      'Phép năm buổi sáng',
                      'Phép năm buổi chiều',
                      'Nghỉ bù',
                      'Nghỉ phép khác'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ))
            ],
          ),
          _dropdownValue == 'Nghỉ phép khác'
              ? Container(
                  margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      border: Border.all(width: 1.2, color: Colors.black12),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(4.0))),
                  child: TextField(
                    controller: _optionController,
                    decoration: InputDecoration(
                      hintText: 'Lựa chọn khác: ',
                      contentPadding: EdgeInsets.all(15.0),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                  ))
              : Container(),
          Container(
              margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 240, 240),
                  border: Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(4.0))),
              child: TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'Lý do: ',
                  contentPadding: EdgeInsets.all(20.0),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                autocorrect: false,
              )),
          Container(
              margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 240, 240),
                  border: Border.all(width: 1.2, color: Colors.black12),
                  borderRadius: BorderRadius.all(const Radius.circular(4.0))),
              child: TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  hintText: 'Liên hệ: ',
                  contentPadding: EdgeInsets.all(15.0),
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
                var _id = DateFormat('yyyyMMdd').format(DateTime.now());
                var _newRecord = {
                  _id: {
                    'reason': _reasonController.text,
                    'contact': _contactController.text,
                    'date': _pickDate,
                    'type': _dropdownValue,
                    'otherType': _optionController.text,
                    'approved': false
                  }
                };
                Firestore.instance
                    .collection('users')
                    .document(widget.currentUser['id'])
                    .setData({'sabbatical': _newRecord}, merge: true);
                Navigator.pop(context);
              },
              child: Text(
                'Send',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Sabbatical extends StatefulWidget {
  final currentUser;
  Sabbatical(this.currentUser);
  @override
  State<StatefulWidget> createState() {
    return SabbaticalState();
  }
}
