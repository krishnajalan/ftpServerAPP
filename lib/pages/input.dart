import 'package:flutter/material.dart';
import 'package:ftpserver/pages/servers.dart';


class InputServer extends StatefulWidget {
  @override
  _InputServerState createState() => _InputServerState();
}

class _InputServerState extends State<InputServer> {

  TextEditingController conName = TextEditingController();
  TextEditingController conIp = TextEditingController();
  TextEditingController conUser = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController conPort = TextEditingController(text: '21');


  void _sendBackData(BuildContext context){
    Server server = Server(serverName: conName.text, username: conUser.text, ip: conIp.text, password: conPass.text, port: conPort.text, );
    Navigator.pop(context, server);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Add New Server"),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [

          SizedBox(height: 5,),

          TextField(
            controller: conName,
            style: TextStyle(color: Colors.amber,),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'ServerName',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 5,),

          TextField(
            controller: conIp,
            style: TextStyle(color: Colors.amber,),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueAccent
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Host Address',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 5,),

          TextField(
            controller: conUser,
            style: TextStyle(color: Colors.amber,),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blueAccent
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Username',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 5,),

          TextField(
            controller: conPass,
            style: TextStyle(color: Colors.amber,),
            obscureText: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blueAccent
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 5,),

          TextField(
            controller: conPort,
            style: TextStyle(color: Colors.amber,),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blueAccent
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: 'port (Optional)',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 5,),

          Center(
            child: RaisedButton(
              onPressed: () {
                _sendBackData(context);
              },
              child: Text('Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(side: BorderSide(
                  color: Colors.blue,
                  width: 1,
                  style: BorderStyle.solid
                ),borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ],
      ),
    );
  }
}


