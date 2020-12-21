import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:c4ivc_flutter/models/look_up_model.dart';
import 'package:c4ivc_flutter/models/zone_type_model.dart';
import 'Globals.dart';

class LookUpService {
  static List<String> reportTypeList = [];
  static List<String> departmentList = [];
  static List<String> zoneList = [];
  static List<Area> areaList = [];
  static List<Area> trafficAreaList = [];

  static LookUpModel _modLookUp;

  // ===========================================================================
  // Get Report Type & Department
  // ===========================================================================
  static loadReportTypeDepartment() async {
    var url = 'http://115.133.238.21:9696/api/lookups?councilId=1';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var lookUpJson = json.decode(response.body);
      _modLookUp = LookUpModel.fromJson(lookUpJson);

      // load ReportTypeList
      _modLookUp.reportTypes.forEach((item) {
        if (!reportTypeList.contains(item.reportTypeName))
          reportTypeList.add(item.reportTypeName);
      });

      // load DepartmentList
      _modLookUp.departments.forEach((item) {
        if (!departmentList.contains(item.departmentName))
          departmentList.add(item.departmentName);
      });

      // load TrafficAreaList
      _modLookUp.areas.forEach((item) {
        if (!trafficAreaList.contains(item.areaName)) trafficAreaList.add(item);
      });
    } else {
      throw Exception('Error Loading LookUp');
    }
  }

  // ===========================================================================
  // Load Area List
  //  + Load the area list and use this to get specific area based on zone
  //  + Store the list as a list of objects
  // ===========================================================================

  static loadAreaType() async {
    var url = 'http://115.133.238.21:9696/api/lookups?councilId=0';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      for (var item in jsonData['Areas']) {
        areaList.add(Area.fromJson(item));
      }
      print(areaList.length);
    } else {
      throw Exception('Error Loading LookUp');
    }
  }

  // ===========================================================================
  // Get Department List
  // ===========================================================================
  static Future<List<String>> getDepartmentList() async {
    var url = 'http://115.133.238.21:9696/api/lookups?councilId=2';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<String> departments = [];
      var zoneListJson = json.decode(response.body);
      for (var item in zoneListJson['Departments']) {
        departments.add(Department.fromJson(item).departmentName);
      }
      return departments;
    } else {
      throw Exception('Error Loading LookUp');
    }
  }

  // ===========================================================================
  // Get Zone By Report Type
  // ===========================================================================
  static Future<List<String>> getZoneByReportType(String name) async {
    var itemId;
    _modLookUp.reportTypes.forEach((item) {
      if (item.reportTypeName == name) itemId = item.reportTypeId;
    });

    var url =
        'http://115.133.238.21:9696/api/reporttypezones?ReportTypeId=$itemId';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<String> zoneTypeList = [];
      var zoneListJson = json.decode(response.body);
      for (var item in zoneListJson) {
        zoneTypeList.add(ZoneTypeModel.fromJson(item).zoneName);
      }
      return zoneTypeList;
    } else {
      throw Exception('Error Loading LookUp');
    }
  }

  // ===========================================================================
  // Get Area List
  // ===========================================================================
  static List<String> getAreaListByZone(String reportType, String zoneName) {
    List<String> areas = [];
    var id;

    _modLookUp.reportTypes.forEach((item) {
      if (reportType == item.reportTypeName) id = item.reportTypeId;
    });

    switch (id) {
      case 1:
      case 44:
        areas = getTrafficAreaListByZone(zoneName);
        break;

      default:
        areas = getOperationAreaListByZone(zoneName);
        break;
    }

    return areas;
  }

  // ===========================================================================
  // Get Area List
  // ===========================================================================
  static List<String> getOperationAreaListByZone(String name) {
    List<String> areas = [];

    var id;

    _modLookUp.zones.forEach((item) {
      if (name == item.zoneName) id = item.zoneId;
    });

    areaList.forEach((item) {
      if (id == item.zoneId) areas.add(item.areaName);
    });

    return areas;
  }

  // ===========================================================================
  // Get Traffic Area List
  // ===========================================================================
  static List<String> getTrafficAreaListByZone(String name) {
    List<String> areas = [];

    var id;

    _modLookUp.zones.forEach((item) {
      if (name == item.zoneName) id = item.zoneId;
    });

    trafficAreaList.forEach((item) {
      if (id == item.zoneId) areas.add(item.areaName);
    });

    return areas;
  }

  // ===========================================================================
  // Get Area Id
  // ===========================================================================
  static int getAreaIdByName(String name) {
    var index;

    areaList.forEach((item) {
      if (name == item.areaName) index = item.areaId;
    });

    trafficAreaList.forEach((item) {
      if (name == item.areaName) index = item.areaId;
    });

    return index;
  }

  // ===========================================================================
  // Get Report Id
  // ===========================================================================
  static int getReportIdByName(String name) {
    var index;
    _modLookUp.reportTypes.forEach((item) {
      if (name == item.reportTypeName) index = item.reportTypeId;
    });
    return index;
  }

  // ===========================================================================
  // Get Area List
  // ===========================================================================
  static List<String> getAreaListByZoneXXX(String name) {
    List<String> serdang = [
      'Serdang 1',
      'Serdang 2',
      'Serdang 3',
      'Serdang 4',
    ];

    List<String> puchong = [
      'Puchong 1',
      'Puchong 2',
      'Puchong 3',
      'Puchong 4',
    ];

    List<String> subang = [
      'Subang 1',
      'Subang 2',
      'Subang 3',
      'Subang 4',
    ];

    if (name == 'Subang') return subang;
    if (name == 'Puchong') return puchong;
    if (name == 'Serdang') return serdang;
  }

  // ===========================================================================
  // Get Area Id
  // ===========================================================================
  static int getAreaIdByNameXXX(String name) {
    Map area = {
      1: 'Subang 1',
      2: 'Subang 2',
      3: 'Subang 3',
      4: 'Subang 4',
      9: 'Puchong 1',
      10: 'Puchong 2',
      11: 'Puchong 3',
      12: 'Puchong 4',
      17: 'Serdang 1',
      18: 'Serdang 2',
      19: 'Serdang 3',
      20: 'Serdang 4',
    };

    // Convert Map to List
    //    var list = [];
    //    list =  subang.entries.map((entry) => "${entry.key} + ${entry.value}").toList();
    // return list;

    var key = area.keys.firstWhere((k) => area[k] == name, orElse: () => null);
    return key;
  }

//  // ===========================================================================
//  // Get Current Report Status
//  // ===========================================================================
//  static int getCurrentReportStatus(String name) {
//    Map map = {
//      1: 'Baharu',
//      2: 'Diterima',
//      3: 'Dalam Tindakan',
//      5: 'Selesai',
//      6: 'Ditutup',
//      7: 'Ditolak',
//      8: 'Dipindah',
//      9: 'Bertindih',
//      10: 'Ditangguh',
//    };
//
//    var key = map.keys.firstWhere((k) => map[k] == name, orElse: () => null);
//    return key;
//  }

  // ===========================================================================
  // Get Report Status Id
  // ===========================================================================
  static int getReportStatusIdByName(String name) {
    Map map = {
      1: 'Baharu',
      2: 'Diterima',
      3: 'Dalam Tindakan',
      5: 'Selesai',
      6: 'Ditutup',
      7: 'Ditolak',
      8: 'Dipindah',
      9: 'Bertindih',
      10: 'Ditangguh',
    };

    // Compare the name to get the key
    var key = map.keys.firstWhere((k) => map[k] == name, orElse: () => null);
    return key;
  }

  // ===========================================================================
  // Get Report Status List
  // ===========================================================================
  static List<String> getCovidStatusList() {
    List<String> statusList = [];
    statusList.add('Baharu');
    statusList.add('Selesai');

    return statusList;
  }

  // ===========================================================================
  // Get Report Status List
  // ===========================================================================
  static List<String> getReportStatusList(String currState) {
    List<String> statusList = [];
    statusList.add('Dalam Tindakan');
    statusList.add('Selesai');
    statusList.add('Ditolak');
    statusList.add('Dipindah');
    statusList.add('Bertindih');

    List<String> dynamicList = [];
    statusList.forEach((item) {
      if (item != currState) dynamicList.add(item);
    });

    return dynamicList;
  }

  // ===========================================================================
  // Get Report Category Id
  // ===========================================================================
  static int getReportCategoryIdByName(String name) {
    var index;
    _modLookUp.reportTypes.forEach((item) {
      if (name == item.reportTypeName) index = item.reportCategoryId;
    });
    return index;
  }

  // ===========================================================================
  // Get Department Id
  // ===========================================================================
  static int getDepartmentIdByName(String name) {
    var index;
    _modLookUp.departments.forEach((item) {
      if (name == item.departmentName) index = item.departmentId;
    });
    return index;
  }

  // ===========================================================================
  // Get Zone Id
  // ===========================================================================
  static int getZoneIdByName(String name) {
    var index;
    _modLookUp.zones.forEach((item) {
      if (name == item.zoneName) index = item.zoneId;
    });
    return index;
  }
}
