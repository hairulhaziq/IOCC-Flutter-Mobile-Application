import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'Login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<bool> _checkSession() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkSession().then((status) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue[900],
          Colors.blue[800],
          Colors.blue[500],
        ])),
        child: Column(
//          fit: StackFit.expand,
//          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(height: 210),
            Image(
              image: AssetImage('assets/img/logo/c4ivc_logo.png'),
              height: 120,
              width: 120,
            ),
            SizedBox(height: 20),
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey[600],
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text(
                      'VIBRANT CITY',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Version 1.2.7726',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
