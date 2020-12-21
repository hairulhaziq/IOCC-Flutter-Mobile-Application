import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text('Tentang Aplikasi'),
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/background/pattern1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 150,
                ),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/img/logo/c4ivc_logo.png'),
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Dibangunkan Oleh'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'System Consultancy Service Sdn Bhd',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Versi 6.1.0 (Binaan 10)'),
              ],
            ),
          ),
        ));
  }
}
