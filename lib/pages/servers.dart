import 'package:flutter/material.dart';
import 'package:ftpserver/pages/Location.dart';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:ftpserver/pages/Loading.dart';

class Server{
  String ip;
  String username;
  String password;
  String serverName;
  String port;

  Server({this.ip, this.username, this.password, this.port = '18', this.serverName = "ftpserver"});

  Server.fromJson(Map<String, dynamic> json):
      ip = json['ip'],
      port = json['port'],
      password = json['password'],
      serverName = json['serverName'],
      username = json['username'];


  Map<String, dynamic> toJson() => {
    'ip': ip,
    'port': port,
    'password': password,
    'username': username,
    'serverName': serverName,
  };

  void removeNull(){
    if (username==null) username="";
    if (ip==null) ip = "";
    if (port==null) port = '21';
    if (serverName==null) serverName = "ftpserver";
    if (password==null) password = "";
  }

}

class FtpPage extends StatefulWidget {

  final Server server;
  FtpPage({Key key, this.server}): super(key: key);
  @override
  _FtpPageState createState() => _FtpPageState();
}

class _FtpPageState extends State<FtpPage> {

  FTPConnect ftp;
  List<Widget> folders = [];
  bool loading = true;

  Widget defineItem(FTPEntry name){

    if (!(name.type == FTPEntryType.DIR || name.type == FTPEntryType.LINK)){
      var data = lookupMimeType(name.name);
      if (data==null)
        return Icon(Icons.insert_drive_file_rounded , color: Colors.grey,);
      else if (data.contains('text'))
        return Icon(Icons.subject_rounded, color: Colors.grey,);
      else if (data.contains('image'))
        return Icon(Icons.image, color: Colors.grey,);
      else if (data.contains('video'))
        return Icon(Icons.movie, color: Colors.grey,);
      else if (data.contains('audio'))
        return Icon(Icons.audiotrack, color: Colors.grey,);
      else
        return Icon(Icons.insert_drive_file_rounded, color: Colors.grey,);
    }
    else{
      return Icon(Icons.folder, color: Colors.grey,);
    }
  }

  Function onPressed(FTPEntry name){
    if (!(name.type == FTPEntryType.DIR || name.type == FTPEntryType.LINK)){
      var data = lookupMimeType(name.name);
      if (data==null)
        return () {};
      else if (data.contains('text'))
        return () {};
      else if (data.contains('image'))
        return () {};
      else if (data.contains('video'))
        return () {};
      else if (data.contains('audio'))
        return (){};
      else return () {};
    }
    else{
      return () async{
        await ftp.changeDirectory(name.name);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Location(ftp: ftp))
        );
      };
    }
  }

  void makeConnection() async {
    try {

      ftp = FTPConnect(
          widget.server.ip,
          user: widget.server.username,
          pass: widget.server.password,
          port: int.parse(widget.server.port)
      );
      await ftp.connect();
      List data = await ftp.listDirectoryContent();
      setState(() {loading=false;});
      for(int i=2; i<data.length; i++){
        setState(() {
          folders.add(
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton.icon(
                  onPressed: onPressed(data[i]),
                  icon: defineItem(data[i]),
                  label: Flexible( flex:5, child: Text(data[i].name, style: TextStyle(color: Colors.grey),)),
                ),
              ),
            )
          );
        });
      }
    } catch (ex){
      print("exception: $ex");
      Navigator.pop(context, "error");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      ftp.disconnect();
    }catch(ex){}
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeConnection();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(widget.server.serverName),
      ),

      body: loading ? Loading():ListView.builder(
        itemCount: folders.length,
        itemBuilder: (BuildContext context, int itemIndex) => folders[itemIndex],
      )
    );
  }
}

class ServerCard extends StatelessWidget {

  final Server server;
  final Function delete;
  final Function connect;
  ServerCard({this.server, this.delete, this.connect});

  @override
  Widget build(BuildContext context) {

    return Card(
        margin: EdgeInsets.all(5),
        color: Colors.grey[850],
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      server.serverName,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 24,
                      )
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton.icon(
                      onPressed: delete,
                      icon: Icon(Icons.delete, size: 24, color: Colors.white),
                      label: Text("", style: TextStyle( color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "host: "+server.ip,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),

                        ),

                        SizedBox(width: 10,),

                        Text(
                          "user: " + server.username,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 10,),

                        Text(
                          "port: ${server.port}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          color: Colors.grey[850],
                          onPressed: connect,
                          child: Text(
                              "Connect",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )
                          )
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}

