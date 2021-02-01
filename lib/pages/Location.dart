import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:ftpserver/pages/Loading.dart';
import 'package:mime/mime.dart';
import 'package:ftpserver/pages/Loading.dart';

class Location extends StatefulWidget {

  final FTPConnect ftp;
  Location({Key key, this.ftp}): super(key: key);
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {


  List<Widget> folders = [];
  String dirName ="";
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  void getDetails() async{
    print('_dir_: $dirName');
    print("current: "+await widget.ftp.currentDirectory());
    dirName = await widget.ftp.currentDirectory();
    print('_dir_: $dirName');
    List data = await widget.ftp.listDirectoryContent();
    setState(() => loading=false);
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
                  label: Flexible(flex: 5,child: Text(data[i].name, style: TextStyle(color: Colors.grey))),
                ),
              ),
            )
        );
      });
    }
  }

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
        await widget.ftp.changeDirectory(name.name);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Location(ftp: widget.ftp))
        );
      };
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.ftp.changeDirectory('..');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: Text(dirName),
        ),
        body: loading ? Loading():ListView.builder(
          itemCount: folders.length,
          itemBuilder: (BuildContext context, int itemIndex) => folders[itemIndex],
        )
    );
  }
}
