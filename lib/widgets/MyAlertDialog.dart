import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  MaterialColor color;
  String title;
  String content;

  MyAlertDialog(this.title, this.content, [this.color = Colors.red]);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        new FlatButton(
          child: const Text(""),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      content: Container(
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Divider(
              thickness: 1,
            ),
            Text(content),
          ],
        ),
        height: 60,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(40))),
      ),
    );
  }
}
