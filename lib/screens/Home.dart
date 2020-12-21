import 'dart:async';
import 'dart:convert';
import 'package:c4ivc_flutter/models/user_account_model.dart';
import 'package:c4ivc_flutter/screens/NewReport.dart';
import 'package:c4ivc_flutter/screens/UserDrawer.dart';
import 'package:c4ivc_flutter/utils/ChangeValueNotifier.dart';
import 'package:c4ivc_flutter/utils/Globals.dart';
import 'package:c4ivc_flutter/utils/SocketUtils.dart';
import 'package:c4ivc_flutter/widgets/GPSActivation.dart';
import 'package:c4ivc_flutter/widgets/ReportList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:background_location/background_location.dart';
import 'package:http/http.dart' as http;
import 'package:c4ivc_flutter/widgets/CustomAlertDialog.dart';

class Home extends StatefulWidget {
  final UserAccountModel userAccount;


  Home(this.userAccount);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _visible = false;
  bool _blink = false;
  Timer _timer;
  String _dropdownValue = Globals.sendInterval;
  String latitude = "";
  String longitude = "";
  String altitude = "";
  String accuracy = "";
  String bearing = "";
  String speed = "";
  String time = "";

  _processSocketData(data) {
    print(data);
    // var content = json.decode(data['Content']);
    var sender = data['Sender'];
    print('SENDER: $sender');
    // if (sender == 'ICPMW.Slave.107') {
      print('Trigger Reload');
      globalKeyReportList.currentState.loadFirstPage();
    // }
//    print(data['Sender']);
//    print(data['Content']);
//    print(content['accountId']);
  }

  setBlink(mode) {
    return _blink = mode;
  }

  _blinkGPS(bool mode) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mode) timer.cancel();
      if (_blink == false) {
        setState(() {
          _visible = true;
        });
      } else {
        setState(() {
          _visible = !_visible;
        });
      }
    });
  }

  // =======================================================================
  // SAVE LOCATION TO DB
  // =======================================================================

  void sendtoRest () async{


    String shapeWKT = this.latitude + ' ' + this.longitude;

    var jsonBody = jsonEncode(<String, dynamic>{
      "AccountID": Globals.userAccount.accountId.toString() ,
      "ShapeWKT": "POINT (" + shapeWKT + ")",
    });

    var apiUrl = 'http://115.133.238.21:9696/api/useraccounts?';
    var response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody);

    print (response.statusCode);

  }

  // =======================================================================
  // INIT STATE:
  // + Initialize and activate SocketIO
  // =======================================================================
  @override
  void initState() {
    /// Blink GPS
    _blinkGPS(true);

    Future.delayed(Duration(seconds: 2), () async {
      var socketUtils = SocketUtils();
      await socketUtils.initSocket();
      socketUtils.connectToSocket();
      socketUtils.setResponderReceivedListener(_processSocketData);
      Globals.socketUtils = socketUtils;
    });

    BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        this.latitude = location.latitude.toString();
        this.longitude = location.longitude.toString();
      });
    });    //Get location

    super.initState();
  }

  // =======================================================================
  // UI WIDGET TREE:
  // =======================================================================
  @override
  Widget build(BuildContext context) {
    final env = Provider.of<Env>(context);
    final appPlatform = Provider.of<AppPlatform>(context);
    final ChangeValueNotifier valueNotifier =
        Provider.of<ChangeValueNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('IOCC (${valueNotifier.getListCounter.toString()})'),
        actions: <Widget>[
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.2,
            duration: Duration(milliseconds: 500),
            child: IconButton(
              color: valueNotifier.getGPSStatus
                  ? Colors.greenAccent
                  : Colors.white,
              onPressed: () {
                _blink = valueNotifier.getGPSStatus;
                Navigator.push(
                    context,
                    appPlatform == AppPlatform.Android
                        ? MaterialPageRoute(
                            builder: (context) => GPSActivation(valueNotifier.getGPSStatus,setBlink))
                        : Container());
              },
              icon: Icon(Icons.gps_fixed),
            ),
          ),
          IconButton(
            onPressed: () {
              BackgroundLocation.startLocationService();
              showDialog(context: context, builder: (context) => CustomAlertDialog());

              // BackgroundLocation.startLocationService(); //Prompt GPS location permission
              //must put delay
              // sendtoRest ();
              //must put delay
            },
            icon: Icon(Icons.add_location_sharp),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              BackgroundLocation.startLocationService(); //Prompt GPS location permission

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewReport('')),
              );
            },
            icon: Icon(Icons.add_circle),
            iconSize: 30,
          ),
        ],
      ),
      drawer: UserDrawer(),
      body: Container(
        child: ReportList(
          key: globalKeyReportList,
          userAccount: widget.userAccount,
        ),
      ),
    );
  }
}

/// =============================================================================
/// Reference:
/// 1. Simple Provider: https://www.youtube.com/watch?v=O71rYKcxUgA
/// 2. Model as a Provider: https://www.youtube.com/watch?v=Md_zBZgVyJo
/// 3. Provider with ChangeNotifier: https://www.youtube.com/watch?v=8II1VPb-neQ
/// 4. Timer: https://fluttermaster.com/tips-to-use-timer-in-dart-and-flutter/
/// =============================================================================
