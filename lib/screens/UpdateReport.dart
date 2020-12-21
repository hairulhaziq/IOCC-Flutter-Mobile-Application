import 'package:c4ivc_flutter/forms/FormCCTV.dart';
import 'package:c4ivc_flutter/forms/FormCovid.dart';
import 'package:c4ivc_flutter/forms/FormGarbage.dart';
import 'package:c4ivc_flutter/forms/FormHalangan.dart';
import 'package:c4ivc_flutter/forms/FormHawker.dart';
import 'package:c4ivc_flutter/forms/FormIklan.dart';
import 'package:c4ivc_flutter/forms/FormLain.dart';
import 'package:c4ivc_flutter/forms/FormSemasa.dart';
import 'package:c4ivc_flutter/forms/FormTraffic.dart';
import 'package:c4ivc_flutter/models/report_model.dart';
import 'package:c4ivc_flutter/utils/SizeConfig.dart';
import 'package:c4ivc_flutter/widgets/Camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';

class UpdateReport extends StatefulWidget {
  final ReportModel report;

  UpdateReport(this.report);

  @override
  _UpdateReportState createState() => _UpdateReportState();
}

class _UpdateReportState extends State<UpdateReport> {
  final TextEditingController remarksController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    print('reportTypeId: ${widget.report.reportTypeId}');
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    String status = widget.report.reportStatusName.toString();

    super.initState();
  }

   @override
  void dispose() {
     remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Kemaskini'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
//        actions: <Widget>[
//          FloatingActionButton(
//              backgroundColor: Colors.black.withOpacity(0),
//              heroTag: null,
//              // Must have
//              elevation: 0,
//              child: Icon(Icons.add_a_photo),
//              onPressed: () {}),
//          FloatingActionButton(
//              backgroundColor: Colors.black.withOpacity(0),
//              heroTag: null,
//              // Must have
//              elevation: 0,
//              child: Icon(Icons.image),
//              onPressed: () {}),
//        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${widget.report.referenceNo}',
                          style: TextStyle(
                              fontFamily: 'Play',
                              fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900]),
                        ),
                        Text(
                          '${widget.report.updatedDateTime}'.substring(11, 16),
                          style: TextStyle(
                              fontFamily: 'Play',
                              fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      height: 380,
                      child: Camera(
                          imageFeeds: widget.report.reportFeeds,
                          key: globalKeyCamera),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Column(
                      children: <Widget>[
                        ConditionalSwitch.single<int>(
                          context: context,
                          valueBuilder: (BuildContext context) =>
                              widget.report.reportTypeId,
                          caseBuilders: {
                            136: (BuildContext context) =>
                                FormLain(widget.report),
                            135: (BuildContext context) =>
                                FormCovid(widget.report),
                            130: (BuildContext context) =>
                                FormSemasa(widget.report),
                            44: (BuildContext context) =>
                                FormCCTV(widget.report),
                            43: (BuildContext context) =>
                                FormHawker(widget.report),
                            5: (BuildContext context) =>
                                FormGarbage(widget.report),
                            4: (BuildContext context) =>
                                FormIklan(widget.report),
                            3: (BuildContext context) =>
                                FormHalangan(widget.report),
                            2: (BuildContext context) =>
                                FormHawker(widget.report),
                            1: (BuildContext context) =>
                                FormTraffic(widget.report),
                          },
                          fallbackBuilder: (BuildContext context) =>
                              Container(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
