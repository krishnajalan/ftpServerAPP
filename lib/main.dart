import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:ftpserver/pages/Location.dart';
import 'package:ftpserver/pages/Loading.dart';
import 'package:ftpserver/pages/input.dart';
import 'package:ftpserver/pages/servers.dart';
import 'package:ftpserver/pages/input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

List<Server> servers = [];

load() async {
  final pref = await SharedPreferences.getInstance();
  final String savedServer = pref.getString("servers");
  if (savedServer==null) {
    servers = [];
  }else{
    final List<dynamic> serverDeserialize = await json.decode(savedServer);
    servers = serverDeserialize.map((json) => Server.fromJson(json)).toList();
    print('server: $servers');
    if (servers == null) {
      servers = [];
    }
    else {
      for (int i = 0; i < servers.length; i++) {
        servers[i].removeNull();
      }
    }
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  await load();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => FTP(),
      '/location': (context) => Location(),
      '/input': (context) => InputServer(),
      '/load': (context) => Loading()
    }
  ));
}

class FTP extends StatefulWidget {
  @override
  _FTPState createState() => _FTPState();
}

class _FTPState extends State<FTP> {

  Map data = {};
  save() async {
    final pref = await SharedPreferences.getInstance();
    final String Sserver = json.encode(servers.map((server) => server.toJson()).toList());
    pref.setString('servers', Sserver);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //load();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text('Error Occured', style: TextStyle(color: Colors.grey),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Connection Error!', style: TextStyle(color: Colors.grey),),
                Text('Check the Server Details.', style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ok', style: TextStyle(color: Colors.amber),),
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
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if (data!=null){
      servers = data['server'];
    }

    save();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar:  AppBar(
        title: Text("Ftp Server"),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView(
        children: servers.map((server)=> ServerCard(
          server: server,
          delete: () { setState(() {
            servers.remove(server);
          });},
          connect: () async{
            print("connect command!");
            String connection = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FtpPage(server: server))
            );
            if (connection == "error") {
              print('error');
              return _showMyDialog();
            }
          }
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        onPressed: () async{
          var server = await Navigator.pushNamed(context, '/input');
          if (server!=null)
            setState(() {
              servers.add(server);
            });
        },
        child: Icon(Icons.add)
      ),
    );
  }
}