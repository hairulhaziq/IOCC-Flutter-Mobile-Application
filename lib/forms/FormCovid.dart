import 'dart:convert';
import 'package:c4ivc_flutter/models/report_model.dart';
import 'package:c4ivc_flutter/utils/ColorConfig.dart';
import 'package:c4ivc_flutter/utils/LookUpService.dart';
import 'package:c4ivc_flutter/utils/SizeConfig.dart';
import 'package:c4ivc_flutter/widgets/Camera.dart';
import 'package:c4ivc_flutter/widgets/ReportList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:c4ivc_flutter/utils/Globals.dart';

class FormCovid extends StatefulWidget {
  final ReportModel report;

  FormCovid(this.report);

  @override
  _FormCovidState createState() => _FormCovidState();
}

class _FormCovidState extends State<FormCovid> {
  final TextEditingController remarksController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  final _key = GlobalKey<FormState>();
  String _selectedAction;

  Future<void> _validateSave() async {
    if (this._key.currentState.validate()) {
      this._key.currentState.save();

      void sendSocketIOMessage(jsonBody) async {
        var main = {};

        main["ReportId"] = widget.report.reportId;
        main["ReportStatusId"] = 1;
        main["AreaName"] = widget.report.areaName;
        main["Title"] = widget.report.title;
        main["CreatedByAccountName"] = Globals.userAccount.accountFullName;
        main["ReferenceNo"] = "";
        main["EstimatedLocation"] = widget.report.estimatedLocation;
        main["ReportCategoryName"] = "";
        main["ReportedByAccountName"] = Globals.userAccount.accountFullName;
        main["ReportStatusName"] = "Baharu";
        main["ReportTypeId"] = widget.report.reportTypeId;
        main["ReportTypeName"] = widget.report.reportTypeName;
        main["UpdatedDateTime"] = Globals.userAccount.updatedDateTime;
        main["ReportFeeds"] = "";
        main["ReportingModeId"] = 1;
        main["CreatedByAccountId"] = Globals.userAccount.accountId;

        String str = json.encode(main);
        print(str);
        Globals.socketUtils.emit(str);
      }

      var jsonBody = jsonEncode(<String, dynamic>{
        "ActionTakenDateTime": null,
        "AreaId": widget.report.areaId,
        "CouncilId": widget.report.councilId,
        "CreatedByAccountId": widget.report.createdByAccountId,
        "DepartmentId": widget.report.departmentId,
        "Description": temperatureController.text,
        "EstimatedLocation": widget.report.estimatedLocation,
        "IsReportedFirst": widget.report.isReportedFirst,
        "IsReporterUnreg": widget.report.isReporterUnreg,
        "ParentReportId": widget.report.parentReportId,
        "PriorityCode": widget.report.priorityCode,
        "Remark": remarksController.text, // Updated
        "ReportCategoryId": widget.report.reportCategoryId,
        "ReportedByAccountId": widget.report.reportedByAccountId,
        "ReportedByUnregAccountId": widget.report.reportedByUnregAccount,
        "ReportId": widget.report.reportId,
        "ReportingModeId": widget.report.reportingModeId,
        "ReportStatusId":
            LookUpService.getReportStatusIdByName(_selectedAction), // Updated
        "ReportTypeId": widget.report.reportTypeId,
        "ShapeWKT": widget.report.shapeWkt,
        "SupervisorAccountId": widget.report.supervisorAccountId,
        "Title": widget.report.title,
        "UpdatedByAccountId": widget.report.updatedByAccountId,
        "ZoneId": widget.report.zoneId
      });

      var apiUrl = 'http://115.133.238.21:9696/api/reports?';
      var response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        var responseString = jsonDecode(response.body);

        print(responseString);
        var reportId = responseString['ReportId'];
        globalKeyCamera.currentState.executeUploadImage(reportId);

        print(reportId.toString() + '   ReportId.......................................');

        //Broadcast message to SocketIO
        sendSocketIOMessage(jsonBody);

        // Update list
        globalKeyReportList.currentState.loadFirstPage();

        // Display prompt
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Maklumat berjaya dikemaskini'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 2000),
        ));

        // Delay before closing the screen
        await Future.delayed(Duration(milliseconds: 2000), () {
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
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black)),
      ],
    );
  }

  @override
  void initState() {
    if (LookUpService.getCovidStatusList()
        .contains(widget.report.reportStatusName)) {
      _selectedAction = widget.report.reportStatusName;
    }

    temperatureController.text = widget.report.description;
    super.initState();
  }

  @override
  void dispose() {
    remarksController.dispose();
    temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              // User info =====================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${widget.report.createdByAccount.accountName}',
                    style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5),
                  ),
                  Text(
                    '${widget.report.reportStatusName}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConfig.getStatusColor(
                            widget.report.reportStatusName),
                        fontSize: SizeConfig.safeBlockHorizontal * 3.2),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                height: 20,
              ),

              // Jenis Pelaporan =================================================
              DropdownTitle('Jenis Pelaporan'),
              TextFormField(
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Colors.grey[600]),
                enabled: false,
                initialValue: '${widget.report.reportTypeName}',
              ),

              // Tajuk ===========================================================
              SizedBox(height: 10),
              DropdownTitle('Tajuk'),
              TextFormField(
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      color: Colors.grey[600]),
                  enabled: false,
                  initialValue: '${widget.report.title ?? ''}'),

              // Zon ===========================================================
              SizedBox(height: 10),
              DropdownTitle('Zon'),
              TextFormField(
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Colors.grey[600]),
                enabled: false,
                initialValue: '${widget.report.zoneName}',
              ),

              // Kawasan =========================================================
              SizedBox(height: 10),
              DropdownTitle('Kawasan'),
              TextFormField(
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Colors.grey[600]),
                enabled: false,
                initialValue: '${widget.report.areaName}',
              ),

              // Catatan Semasa ==================================================
              SizedBox(height: 10),
              DropdownTitle('Catatan Semasa'),
              TextFormField(
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Colors.grey[600]),
                enabled: false,
                initialValue: '${widget.report.remark ?? ''}',
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),

              // Suhu ============================================================
              SizedBox(height: 10),
              DropdownTitle('Suhu'),
              TextFormField(
                style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4),
//                initialValue: '${widget.report.description ?? ''}',
                controller: temperatureController,
              ),

              // Tindakan ========================================================
              SizedBox(height: 10),
              DropdownTitle('Tindakan'),
              DropdownButtonFormField<String>(
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Colors.black),
                value: _selectedAction,
                hint: Text(
                  'Pilih Tindakan',
                ),
                onChanged: (value) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  setState(() => _selectedAction = value);
                  _key.currentState.validate();
                },
                validator: (value) =>
                    value == null ? 'Sila Pilih Tindakan' : null,
                items: LookUpService.getCovidStatusList()
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              // Catatan ===================================================
              SizedBox(height: 15),
              DropdownTitle('Catatan'),
              TextFormField(
                decoration:
                    InputDecoration(hintText: 'Sila isikan catatan ringkas'),
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
                        _validateSave();
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        "SIMPAN",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}

// How to set initial value for dropdown?
