import 'dart:convert';
import 'package:c4ivc_flutter/models/look_up_model.dart';
import 'package:c4ivc_flutter/models/zone_type_model.dart';
import 'package:c4ivc_flutter/utils/ChangeValueNotifier.dart';
import 'package:c4ivc_flutter/utils/LookUpService.dart';
import 'package:c4ivc_flutter/utils/Globals.dart';
import 'package:c4ivc_flutter/widgets/Carousel.dart';
import 'package:c4ivc_flutter/widgets/ReportList.dart';
import 'package:flutter/material.dart';
import 'package:c4ivc_flutter/widgets/MyAlertDialog.dart';
import 'package:provider/provider.dart';
import '../widgets/Camera.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:background_location/background_location.dart';

class NewReport extends StatefulWidget {
  final String photo;

  NewReport(this.photo);

  @override
  _NewReportState createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  final _key = GlobalKey<FormState>();

  String _selectedReportType;
  String _selectedZoneName;
  String _selectedAreaName;
  String _selectedDepartmentName;

  String latitude = "";
  String longitude = "";
  String altitude = "";
  String accuracy = "";
  String bearing = "";
  String speed = "";
  String time = "";


  List<String> _currentZoneList = [];
  List<String> _currentAreaList = [];

  void sendSocketIOMessage(jsonBody, reportId) async {
    var main = {};

    main["ReportId"] = reportId;
    main["ReportStatusId"] = 1;
    main["AreaName"] = _selectedAreaName;
    main["Title"] = titleController.text;
    main["CreatedByAccountName"] = Globals.userAccount.accountFullName;
    main["ReferenceNo"] = "";
    main["EstimatedLocation"] = locationController.text;
    main["ReportCategoryName"] = "";
    main["ReportedByAccountName"] = Globals.userAccount.accountFullName;
    main["ReportStatusName"] = "Baharu";
    main["ReportTypeId"] = LookUpService.getReportIdByName(_selectedReportType);
    main["ReportTypeName"] = "";
    main["UpdatedDateTime"] = Globals.userAccount.updatedDateTime;
    main["ReportFeeds"] = "";
    main["ReportingModeId"] = 1;
    main["CreatedByAccountId"] = Globals.userAccount.accountId;

    String str = json.encode(main);
    print(str);
    Globals.socketUtils.emit(str);
  }

  //get latitude and longitude
  @override
  void initState() {
    super.initState();

    BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        this.latitude = location.latitude.toString();
        this.longitude = location.longitude.toString();
      });
    });
  }

  Future <void> _validateSave() async {
    if (this._key.currentState.validate()) {
      this._key.currentState.save();


      String latlong = this.longitude.toString() + ' ' + this.latitude.toString();



      var jsonBody = jsonEncode(<String, dynamic>{
        "ActionTakenDateTime": null,
        "AreaId": LookUpService.getAreaIdByName(_selectedAreaName),
        "CouncilId": Globals.userAccount.councilId,
        "CreatedByAccountId": Globals.userAccount.accountId,
        "DepartmentId": _selectedReportType == 'Lain-lain'
            ? LookUpService.getDepartmentIdByName(_selectedDepartmentName)
            : Globals.userAccount.departmentId,
        "Description": remarksController.text,
        "EstimatedLocation": locationController.text,
        "IsReportedFirst": true,
        "IsReporterUnreg": false,
        "ParentReportId": null,
        "PriorityCode": null,
        "Remark": remarksController.text,
        "ReportCategoryId":
            LookUpService.getReportCategoryIdByName(_selectedReportType),
        "ReportedByAccountId": Globals.userAccount.accountId,
        "ReportedByUnregAccountId": null,
        "ReportId": 0,
        "ReportingModeId": 1,
        "ReportStatusId": 1,
        "ReportTypeId": LookUpService.getReportIdByName(_selectedReportType),
        // "ShapeWKT": "POINT (0 0)",
        // "ShapeWKT": "POINT (" + latlong + ")",
        "ShapeWKT": "POINT (" + this.longitude.toString() + " " + this.latitude.toString() + ")",
        // "ShapeWKT": this.latitude.toString(),
        "SupervisorAccountId": null,
        "Title": titleController.text,
        "UpdatedByAccountId": Globals.userAccount.accountId,
        "ZoneId": LookUpService.getZoneIdByName(_selectedZoneName)
      });

      var apiUrl = 'http://115.133.238.21:9696/api/reports?';
      var response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      print(jsonBody);
      print (response.statusCode);

      if (response.statusCode == 200) {
        var responseString = jsonDecode(response.body);

        print(responseString);
        var reportId = responseString['ReportId'];
        globalKeyCamera.currentState.executeUploadImage(reportId);

        print(reportId.toString() + ' ..................ReportId..................');

        //Broadcast message to SocketIO
        sendSocketIOMessage(jsonBody, reportId);

        // Update list
        globalKeyReportList.currentState.loadFirstPage();

        // Display prompt
        //TODO: Displaying a prompt as a showModalBottomSheet
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 36.0,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Text(
                    'Maklumat berjaya disimpan',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            height: 150,
          ),
        );

        // Delay before closing the screen
        await Future.delayed(Duration(milliseconds: 3000), () {
          Navigator.pop(context);
          Navigator.of(context).pop();
        });

        return true;
      } else {
        return false;
      }
    }
  }

  Widget DropdownTitle(title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    titleController.dispose();
    remarksController.dispose();
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Tugasan Baharu'),
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
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  // Image =====================================================
                  Container(
                    height: 380,
                    child: Camera(imageFeeds: [], key: globalKeyCamera),
                  ),
                  Divider(
                    thickness: 1,
                    height: 10,
                  ),
                  // Jenis Laporan =============================================
                  SizedBox(height: 15),
                  DropdownTitle('Jenis Laporan'),
                  DropdownButtonFormField<String>(
                    value: _selectedReportType,
                    hint: Text(
                      'Pilih Jenis Laporan',
                    ),
                    onChanged: (value) async {
                      _selectedReportType = value;
                      if (value != 'Lain-lain') {
                        // Get zone list
                        _currentZoneList =
                            await LookUpService.getZoneByReportType(value);
                        _selectedZoneName = _currentZoneList[0];

                        // Get area list
                        _currentAreaList = LookUpService.getAreaListByZone(
                            value, _selectedZoneName);
                        _selectedAreaName = _currentAreaList[0];
                      } else {
                        _currentZoneList = [];
                        _selectedZoneName = '';
                        _currentAreaList = [];
                        _selectedAreaName = '';
                      }

                      setState(() {
                        _selectedReportType = value;
                        _key.currentState.reset();
                      });
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    validator: (value) =>
                        value == null ? 'Sila Pilih Jenis Laporan' : null,
                    items: LookUpService.reportTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  // Tajuk =====================================================
                  SizedBox(height: 10),
                  DropdownTitle('Tajuk'),
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Sila isikan tajuk laporan'),
                    controller: titleController,
                  ),

                  // Jabatan ===================================================
                  Visibility(
                    visible: _selectedReportType == 'Lain-lain',
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15),
                        DropdownTitle('Jabatan'),
                        DropdownButtonFormField<String>(
                          value: _selectedDepartmentName,
                          hint: Text(
                            'Pilih Jabatan',
                          ),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {
                              _selectedDepartmentName = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Sila Pilih Jabatan' : null,
                          items: LookUpService.departmentList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.043),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Lokasi ====================================================
                  Visibility(
                    visible: _selectedReportType == 'Lain-lain',
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        DropdownTitle('Lokasi'),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Sila isikan lokasi'),
                          controller: locationController,
                        ),
                      ],
                    ),
                  ),

                  // Zon =======================================================
                  Visibility(
                    visible: _selectedReportType != 'Lain-lain',
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15),
                        DropdownTitle('Zon'),
                        DropdownButtonFormField<String>(
                          value: _selectedZoneName,
                          hint: Text(
                            'Pilih Zon',
                          ),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {
                              _selectedZoneName = value;
                              _currentAreaList =
                                  LookUpService.getAreaListByZone(
                                      _selectedReportType, _selectedZoneName);
                              _selectedAreaName = _currentAreaList[0];
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Sila Pilih Zon' : null,
                          items: _currentZoneList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Kawasan ===================================================
                  Visibility(
                    visible: _selectedReportType != 'Lain-lain',
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15),
                        DropdownTitle('Kawasan'),
                        DropdownButtonFormField<String>(
                          value: _selectedAreaName,
                          hint: Text(
                            'Pilih Kawasan',
                          ),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {
                              _selectedAreaName = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Sila Pilih Kawasan' : null,
                          items: _currentAreaList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Catatan ===================================================
                  SizedBox(height: 15),
                  DropdownTitle('Catatan'),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Sila isikan catatan ringkas'),
                    keyboardType: TextInputType.multiline,
                    controller: remarksController,
                    maxLines: null,
                  ),

                  // Save Button ===============================================
                  SizedBox(height: 15),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _validateSave();
                          },
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            "SIMPAN",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white),
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// References
// https://stacksecrets.com/flutter/how-to-call-method-of-a-child-widget-from-parent-in-flutter
// https://stackoverflow.com/questions/53692798/flutter-calling-child-class-function-from-parent-class
