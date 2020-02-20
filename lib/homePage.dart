import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkTime.dart';
import 'sabbatical.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser currentUser;

  HomePage(this.currentUser);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var loggedUser = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AZoom VIETNAM INC."),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'Hi,',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Welcome ${widget.currentUser.email}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Image.asset('images/user.png',
                          width: 80.0, height: 80.0, fit: BoxFit.fitWidth),
                      Text(
                        '',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.currentUser.email,
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                      Text('',
                          style: TextStyle(color: Colors.white, fontSize: 12.0))
                    ])),
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Check in/out'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CheckTime({'id': widget.currentUser.email})));
                },
              ),
              ListTile(
                leading: Icon(Icons.card_travel),
                title: Text('Sabbatical'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Sabbatical({'id': widget.currentUser.email})));
                },
              ),
              Divider(color: Colors.black45, indent: 16.0),
              ListTile(leading: Icon(Icons.info), title: Text('About us')),
              ListTile(leading: Icon(Icons.security), title: Text('Privacy')),
              ListTile(
                  leading: Icon(Icons.subdirectory_arrow_left),
                  title: Text('Logout'),
                  onTap: () async {
                    await Provider.of<AuthService>(context).logout();
                  })
            ],
          ),
        ));
  }
}
