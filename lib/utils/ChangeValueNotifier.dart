import 'package:flutter/material.dart';

class ChangeValueNotifier extends ChangeNotifier {
  // ===================================================
  // Main List Counter
  // ===================================================
  int _listCounter = 0;

  int get getListCounter => _listCounter;

  set listCounter(int val) {
    _listCounter = val;
    notifyListeners();
  }

  setListCounter(val) {
    listCounter = val;
  }

  // ===================================================
  // GPS Status
  // ===================================================
  bool _gpsStatus = false;

  bool get getGPSStatus => _gpsStatus;

  set gpsStatus(bool val) {
    _gpsStatus = val;
    notifyListeners();
  }

  setGPSStatus(val) {
    gpsStatus = val;
  }

  // ===================================================
  // Alert Status
  // ===================================================
  bool _alertStatus = false;

  bool get getAlertStatus => _alertStatus;

  set alertStatus(bool val) {
    _alertStatus = val;
    notifyListeners();
  }

  setAlertStatus(val) {
    alertStatus = val;
  }
}
