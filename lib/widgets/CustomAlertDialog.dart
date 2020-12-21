import 'dart:async';
import 'dart:convert';
import 'package:c4ivc_flutter/utils/Globals.dart';
import 'package:c4ivc_flutter/utils/SocketUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:provider/provider.dart';
import 'package:c4ivc_flutter/utils/ChangeValueNotifier.dart';
import 'package:http/http.dart' as http;

class CustomAlertDialog extends StatefulWidget {
  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  String title, description, buttonText;
  Image image;
  String latitude = 'menjejak latitud...';
  String longitude = 'menjejak longitud...';
  String time = 'menyemak masa...';


  // get latlong
  @override
  void initState() {
    super.initState();

    BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        this.latitude = location.latitude.toString();
        this.longitude = location.longitude.toString();
        this.time = DateTime.fromMillisecondsSinceEpoch(location.time.toInt())
            .toString();
      });
    });
  }

  // save and update latlong to restapi
  Future <void> _sendtoRest() async {
    String shapeWKT = this.longitude + ' ' + this.latitude;

    var jsonBody = jsonEncode(<String, dynamic>{
      "AccountID": Globals.userAccount.accountId.toString(),
      "ShapeWKT": "POINT (" + shapeWKT + ")",
    });

    var apiUrl = 'http://115.133.238.21:9696/api/accounttracks?';
    var response = await http.post (apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody);

    print(response.statusCode);
    print (jsonBody);

    if (response.statusCode == 200) {
      var responseString = jsonDecode(response.body);

      print(responseString);
      print(response.statusCode);

    } else {
      throw Exception('Failed to update latitude and longitude.');
    }
  }

  // UI for dialog box
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Hantar lokasi anda",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  // backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 16.0),
              locationData("Latitude: " + latitude),
              locationData("Longitude: " + longitude),
              locationData("Time: " + time),
              // Text("description", style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    _sendtoRest();
                  },
                  child: Text("HANTAR", style: TextStyle(fontSize: 16.0)),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 55  ,
            backgroundImage: AssetImage('assets/img/photo/right_tick.gif'),
          ),
        )
      ],
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
