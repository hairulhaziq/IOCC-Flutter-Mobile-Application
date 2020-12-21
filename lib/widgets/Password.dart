import 'dart:async';
import 'package:c4ivc_flutter/utils/Hashing.dart';
import 'package:c4ivc_flutter/widgets/MyAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  String _oldPassword = '';
  String _newPassword = '';
  String _verifyPassword = '';
  final _key = GlobalKey<FormState>();

  Future<String> _updatePassword(
      int accountId, String oldPassword, String newPassword) async {
    var apiUrl =
        'http://115.133.238.21:9696/api/userAccounts?identificationNumber=${accountId}&oldPassword=${oldPassword}&newPassword=${newPassword}';
    print(apiUrl);
    var response = await http.put(apiUrl);

    print(response.statusCode);
    if (response.statusCode == 201) {
      final String responseBody = response.body;
      return responseBody;
    } else {
      return 'Error Code: ${response.statusCode}';
    }
  }

  _validateSave() {
    if (this._key.currentState.validate()) {
      this._key.currentState.save();

      String hashOldPassword = MD5Hashing.createPasswordHash(_oldPassword);
      String hashNewPassword = MD5Hashing.createPasswordHash(_newPassword);
      _updatePassword(210, hashOldPassword, hashNewPassword).then((value) {
        showDialog(
          context: context,
          builder: (context) {
            return MyAlertDialog('Error Fetching Data', value);
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Tukar Katalaluan'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _oldPassword,
                    decoration: InputDecoration(
                      labelText: 'Katalaluan Lama',
                    ),
                    validator: (value) {
                      int len = value.trim().length;
                      if (len == 0) {
                        return 'Sila isikan Katalaluan Lama';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _oldPassword = value;
                    },
                    onChanged: (value) {
                      _key.currentState.validate();
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    initialValue: _newPassword,
                    decoration: InputDecoration(
                      labelText: 'Katalaluan Baru',
                    ),
                    validator: (value) {
                      int len = value.trim().length;
                      if (len == 0) {
                        return 'Sila isikan Katalaluan Baru';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _newPassword = value;
                    },
                    onChanged: (value) {
                      _key.currentState.validate();
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    initialValue: _verifyPassword,
                    decoration: InputDecoration(
                      labelText: 'Sahkan Katalaluan Baru',
                    ),
                    validator: (value) {
                      int len = value.trim().length;
                      if (len == 0) {
                        return 'Sila isikan Katalaluan Lama untuk pengesahan';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _verifyPassword = value;
                    },
                    onChanged: (value) {
                      _key.currentState.validate();
                    },
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        _validateSave();
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        "SIMPAN",
                        style: TextStyle(fontSize: 13.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
