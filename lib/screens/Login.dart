import 'dart:async';
import 'package:c4ivc_flutter/utils/ChangeValueNotifier.dart';
import 'package:c4ivc_flutter/utils/LookUpService.dart';
import 'package:c4ivc_flutter/utils/Globals.dart';
import 'package:c4ivc_flutter/utils/Hashing.dart';
import 'package:c4ivc_flutter/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:c4ivc_flutter/models/user_account_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:background_location/background_location.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LoginBody(),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  bool _isDisplayLogin = true;
  String _userId = 'mpsj_op2_1';
  String _userPassword = 'mpsj_op2_1';

//  String _userName = 'mpsj_utt1_1';
//  String _userName = ' mpsj_op2_1';
//  String _userName = 'ker_jab8_1';

  UserAccountModel _userAccount = UserAccountModel();

  var _passwordVisible = true;

  Future<bool> _checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    return false;
  }

  Future<UserAccountModel> _validateUserAccount(
      String userId, String password) async {
    String hashPassword = MD5Hashing.createPasswordHash(password);

    var url =
        'http://115.133.238.21:9696/api/userAccounts?identificationNumber=${userId}&password=${hashPassword}';

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var accountJson = json.decode(response.body);
      print(accountJson);
      if (accountJson['AccountId'] == 0) {
        return null;
      } else {
        var userAccount = UserAccountModel.fromJson(accountJson);
        return userAccount;
      }
    } else {
      throw Exception('Akaun pengguna tidak dapat di akses');
    }
  }

  final _key = GlobalKey<FormState>();

  _validateLogin() async {
    if (this._key.currentState.validate()) {
      this._key.currentState.save();

      _validateUserAccount(_userId, _userPassword).then((value) async {
        print('return $value');

        if (value == null) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('ID Pengguna atau Katalaluan salah'),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 1500),
          ));
          return;
        } else {
          _userAccount = value;
          addStringToSF();

          // Store the account data in Globals
          _userAccount.identificationNumber = _userId;
          Globals.userAccount = _userAccount;

          // Load LookUp
          LookUpService.loadReportTypeDepartment();

          //Prompt GPS permission
          BackgroundLocation.getPermissions(
            onGranted: () {
              BackgroundLocation.startLocationService();
            },
            onDenied: () {
              // Show a message asking the user to reconsider or do something else
            },
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(this._userAccount)),
          );
        }
      });
    }
  }

  _reLogin(String userId, String userPassword) {
    _validateUserAccount(userId, userPassword).then((value) async {
      if (value == null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('ID Pengguna atau Katalaluan salah'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1500),
        ));
        return;
      } else {
        _userAccount = value;
        addStringToSF();

        // Store the account data in Globals
        _userAccount.identificationNumber = _userId;
        Globals.userAccount = _userAccount;

        // Load LookUp
        LookUpService.loadReportTypeDepartment();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(this._userAccount)),
        );
      }
    });
  }

  // https://medium.com/flutterdevs/using-sharedpreferences-in-flutter-251755f07127
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', _userId);
    prefs.setString('userPassword', _userPassword);
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');
    String userPassword = prefs.getString('userPassword');
    setState(() {
      if (userId.length > 0) {
        _userId = userId;
        _userPassword = userPassword;
        _isDisplayLogin = false;
        _reLogin(userId, userPassword);
      } else {
        _isDisplayLogin = true;
      }
    });
  }

  @override
  void initState() {
    getStringValuesSF();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LookUpService.loadAreaType();
//      LookUpService.loadReportTypeDepartment();
    });
  }

  @override
  Widget build(BuildContext context) {
//    final CounterBloc counterBloc = Provider.of<CounterBloc>(context);
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Stack(children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Image(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/img/background/bck_login.jpg'),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),

                  // Form =======================================
                  child: Form(
                    key: _key,
                    child: Opacity(
                      opacity: _isDisplayLogin ? 1 : 0,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: _userId,
                            onChanged: (value) {
                              _key.currentState.validate();
                            },
                            validator: (value) {
                              int len = value.trim().length;
                              if (len == 0) {
                                return 'Sila isikan ID Pengguna';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _userId = value;
                            },
                            decoration:
                                InputDecoration(labelText: 'ID Pengguna'),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            initialValue: _userPassword,
                            onChanged: (value) {
                              _key.currentState.validate();
                            },
                            validator: (value) {
                              int len = value.trim().length;
                              if (len == 0) {
                                return 'Sila isikan Katalaluan';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _userPassword = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Katalaluan',
                              hintText: 'Sila masukkan katalaluan',
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: _passwordVisible,
                          ),
                          SizedBox(height: 30),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                  onPressed: () {
                                    _validateLogin();
                                  },
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    "MASUK",
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.white),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
