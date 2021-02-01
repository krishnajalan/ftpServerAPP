import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ftpserver/pages/servers.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {



  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SpinKitRing(
        color: Colors.amber,
        size: 60,
      )
    );
  }
}
