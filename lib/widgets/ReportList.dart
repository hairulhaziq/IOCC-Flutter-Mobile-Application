import 'dart:convert';
import 'package:c4ivc_flutter/models/report_model.dart';
import 'package:c4ivc_flutter/models/user_account_model.dart';
import 'package:c4ivc_flutter/screens/UpdateReport.dart';
import 'package:c4ivc_flutter/utils/ChangeValueNotifier.dart';
import 'package:c4ivc_flutter/utils/ColorConfig.dart';
import 'package:c4ivc_flutter/utils/Globals.dart';
import 'package:c4ivc_flutter/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

GlobalKey<_ReportState> globalKeyReportList = GlobalKey();

class ReportList extends StatefulWidget {
  final UserAccountModel userAccount;

  const ReportList({Key key, this.userAccount}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ReportList> {
  List<ReportModel> _reports = List<ReportModel>();
  bool _isLoading = true;
  var _scrollController = ScrollController();
  int _paging = 1;


  // void getImage (){
  //    if (item.reportFeeds.length > 0)
  //        NetworkImage(
  //       'http://115.133.238.21:96/uploaded/${item.reportFeeds[0].mediaFileName}')
  //        else
  //       AssetImage(
  //       'assets/img/background/no_image.png')
  // }

  // ============================================================
  // Public Access Method: Refresh List
  // ============================================================
  Future<bool> loadFirstPage() async {
    print('loadFirstPage');
    final value = await _loadReport(1);
    print('load page 1');
    setState(() {
      _reports.clear();
      _reports.addAll(value);
      _isLoading = false;
      Provider.of<ChangeValueNotifier>(context, listen: false)
          .setListCounter(_reports.length);
    });
    return true;
  }

  // ============================================================
  // Load Report
  // Get Timeout: https://stackoverflow.com/questions/51487818/set-timeout-for-httpclient-get-request
  // ============================================================
  Future<List<ReportModel>> _loadReport(int page) async {
    var reports = List<ReportModel>();
    var url =
        'http://115.133.238.21:9696/api/reports?accountId=${widget.userAccount.accountId}&startDate=null&endDate=null&pageNo=$page&sortId=2';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var reportsJson = json.decode(response.body);
      for (var reportJson in reportsJson) {
        reports.add(ReportModel.fromJson(reportJson));
      }
    } else {
      // Display prompt
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[
            Text('Loading Error : ${response.statusCode}'),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ));
      loadFirstPage();
    }

    return reports;
  }

  // ============================================================
  // Init State
  // ============================================================
  @override
  void initState() {
    // Initially load the first page
    loadFirstPage();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _paging = _paging + 1;

        print('load page ${_paging}');
        _loadReport(_paging).then((value) {
          setState(() {
            _reports.addAll(value);
            _isLoading = false;
            Scaffold.of(context).hideCurrentSnackBar();
            Provider.of<ChangeValueNotifier>(context, listen: false)
                .setListCounter(_reports.length);
          });
        });

        // Display prompt
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                width: 20,
              ),
              Text('Muat turun laporan terdahulu...'),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.7),
          duration: Duration(minutes: 5),
        ));
      }
    });

    super.initState();
  }

  // ============================================================
  // Dispose
  // ============================================================
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // UI Widget Tree
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final env = Provider.of<Env>(context);
    SizeConfig().init(context);
    return Container(
        child: Scaffold(
            body: Stack(
      children: <Widget>[
        Container(
          color: Colors.white60,
          child: Scrollbar(
            child: RefreshIndicator(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: null == _reports ? 0 : _reports.length,
                  itemBuilder: (context, index) {
                    ReportModel item = _reports[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateReport(item),
                          ),
                        );
                      },
                      child: Card(
                        color:
                            ColorConfig.getStatusColor(item.reportStatusName),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 15,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      // Title =================================
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '${item.referenceNo}',
                                            style: TextStyle(
                                                fontFamily: 'Play',
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    4.3,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          ),
                                          Text(
                                            '${item.updatedDateTime}'
                                                .substring(11, 16),
                                            style: TextStyle(
                                                fontFamily: 'Play',
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    4.3,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      // Report Type ===========================
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            item.reportTypeName != null
                                                ? '${item.reportTypeName}'
                                                : '',
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    3.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),

                                      // Report Content ========================
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  39,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    item.reportingModeId != 1
                                                        ? '${item.reportingModeName}'
                                                        : '${item.createdByAccount.accountName}',
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            3.5,
                                                        color:
                                                            Colors.orange[700],
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${item.areaName}',
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            3.5,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    '${item.reportStatusName}',
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            3.5,
                                                        color: ColorConfig
                                                            .getStatusColor(item
                                                                .reportStatusName),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                            Container(
                                            height: 118,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.44,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: item.reportFeeds.length > 0 ? NetworkImage('http://175.138.60.122/uploaded/${item.reportFeeds[0].mediaFileName}')
                                                      // item.reportFeeds.length > 0 ? NetworkImage('http://115.133.238.21:96/uploaded/${item.reportFeeds[0].mediaFileName}')
                                                      // : item.reportingModeId == 8 ? NetworkImage('http://175.138.60.122/uploaded/${item.reportFeeds[0].mediaFileName}')
                                                      // : item.reportingModeId == 11 ? NetworkImage('http://115.133.238.21:96/IOCC.Media/snapShots/192.168.116.44/vehicleEvents/${item.reportFeeds[0].mediaFileName}')
                                                      // : item.reportingModeId == 12 ? NetworkImage('115.133.238.21:96/IOCC.Media/snapShots/192.168.116.43/${item.reportFeeds[0].mediaFileName}')
                                                      : AssetImage('assets/img/background/no_image.png')
                                                  // AssetImage('assets/img/background/no_image.png')
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        elevation: 5,
                      ),
                    );
                  }),
              onRefresh: () {
                return loadFirstPage();
              },
            ),
          ),
        ),
        LoadingOverlay(
          child: Container(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                  child:
                      Text(_isLoading ? 'Laporan sedang dikemaskini' : ''))),
          isLoading: _isLoading,
        ),
      ],
    )));
  }
}
