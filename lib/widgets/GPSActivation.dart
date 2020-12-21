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

// ignore: slash_for_doc_comments
/**************************** Notes ***********************************************

    1.  Tambah Dekat AndroidManifest.xml
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

    2. Tambah Dekat pubspec.yaml
    background_location: ^0.1.1

 *************************************************************************************/

class GPSActivation extends StatefulWidget {
  final Function func;
  final bool statusGPS;

  GPSActivation(this.statusGPS, this.func);

  @override
  _GPSActivationState createState() => _GPSActivationState();
}

class _GPSActivationState extends State<GPSActivation> {
  Timer _timer;
  String _dropdownValue = Globals.sendInterval;
  String latitude = "";
  String longitude = "";
  String altitude = "";
  String accuracy = "";
  String bearing = "";
  String speed = "";
  String time = "";

  bool _switchState;

  SocketUtils _socketUtils;

  @override
  void initState() {
    super.initState();

    _switchState = widget.statusGPS;

//    BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        this.latitude = location.latitude.toString();
        this.longitude = location.longitude.toString();
        this.accuracy = location.accuracy.toString();
        this.altitude = location.altitude.toString();
        this.bearing = location.bearing.toString();
        this.speed = location.speed.toString();
        this.time = DateTime.fromMillisecondsSinceEpoch(location.time.toInt())
            .toString();
      });

      print("""\n
      Latitude:  $latitude
      Longitude: $longitude
      Altitude: $altitude
      Accuracy: $accuracy
      Bearing:  $bearing
      Speed: $speed
      Time: $time
      """);
    });
  }

  // Interval to send location
  void setSendTimer(String interval) {
    if (_switchState) {
      if (_timer != null) _timer.cancel();

      _timer =
          Timer.periodic(Duration(seconds: (int.parse(interval) * 5)), (timer) {
        print(DateTime.now());

        sendMessage();

        // Turn off timer if GPS is disabled
        if (_switchState == false) {
          if (_timer != null) _timer.cancel();
        }
      });
    }
  }

  void sendMessage() async {
    var main = {};

    main["EnforcerId"] = Globals.userAccount.accountId;
    main["EnforcerName"] = Globals.userAccount.accountProfileName;
    main["Latitude"] = double.parse(this.longitude);
    main["Longitude"] = double.parse(this.latitude);
    main["Course"] = 0.0;
    main["BatteryPercentage"] = "";

    String str = json.encode(main);
    Globals.socketUtils.emit(str);
    sendtoRest();
  }

  void sendtoRest () async{


      String shapeWKT = this.longitude + ' ' + this.latitude;

    var jsonBody = jsonEncode(<String, dynamic>{
      "AccountID": Globals.userAccount.accountId.toString() ,
      "ShapeWKT": "POINT (" + shapeWKT + ")",
    });

    var apiUrl = 'http://115.133.238.21:9696/api/accounttracks?';
    var response = await http.post(
    apiUrl,
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonBody);

    print (response.statusCode);
    print (jsonBody);

  }
  @override
  Widget build(BuildContext context) {
    final ChangeValueNotifier valueNotifier =
        Provider.of<ChangeValueNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('GPS'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background/pattern1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                locationData("Latitude: " + latitude),
                locationData("Longitude: " + longitude),
//              locationData("Altitude: " + altitude),
//              locationData("Accuracy: " + accuracy),
//              locationData("Bearing: " + bearing),
//              locationData("Speed: " + speed),
                locationData("Time: " + time),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 2,
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Aktifkan GPS',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CupertinoSwitch(
                      value: _switchState,
                      onChanged: (bool value) {
                        setState(() {
                          valueNotifier.setGPSStatus(value);
                          widget.func(value);
                          _switchState = value;
                          if (!value) {
                            BackgroundLocation.stopLocationService();
                            this.latitude = '';
                            this.longitude = '';
                            this.time = '';
                          } else {
                            BackgroundLocation.startLocationService();
                            setSendTimer(_dropdownValue);
                            this.latitude = 'waiting...';
                            this.longitude = 'waiting...';
                            this.time = 'waiting...';
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Hantar Lokasi Setiap',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 50,
                      child: DropdownButton(
                        isExpanded: true,
                        items: <String>['1', '5', '10'].map((String value) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            value: value,
                          );
                        }).toList(),
                        value: _dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                            Globals.sendInterval = newValue;
                            setSendTimer(newValue);
                          });
                        },
                      ),
                    ),
                    Text(
                      'minit',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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

  getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print("This is Latitude Location : " + location.latitude.toString());
      print("This is Longitude Location : " + location.longitude.toString());
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
