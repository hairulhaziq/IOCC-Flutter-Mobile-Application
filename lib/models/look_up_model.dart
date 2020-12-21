// To parse this JSON data, do
//
//     final lookUp = lookUpFromJson(jsonString);

import 'dart:convert';

LookUpModel lookUpFromJson(String str) => LookUpModel.fromJson(json.decode(str));

String lookUpToJson(LookUpModel data) => json.encode(data.toJson());

class LookUpModel {
  LookUpModel({
    this.reportCategories,
    this.reportTypes,
    this.zones,
    this.areas,
    this.departments,
  });

  List<ReportCategory> reportCategories;
  List<ReportType> reportTypes;
  List<Zone> zones;
  List<Area> areas;
  List<Department> departments;

  factory LookUpModel.fromJson(Map<String, dynamic> json) => LookUpModel(
    reportCategories: List<ReportCategory>.from(json["ReportCategories"].map((x) => ReportCategory.fromJson(x))),
    reportTypes: List<ReportType>.from(json["ReportTypes"].map((x) => ReportType.fromJson(x))),
    zones: List<Zone>.from(json["Zones"].map((x) => Zone.fromJson(x))),
    areas: List<Area>.from(json["Areas"].map((x) => Area.fromJson(x))),
    departments: List<Department>.from(json["Departments"].map((x) => Department.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ReportCategories": List<dynamic>.from(reportCategories.map((x) => x.toJson())),
    "ReportTypes": List<dynamic>.from(reportTypes.map((x) => x.toJson())),
    "Zones": List<dynamic>.from(zones.map((x) => x.toJson())),
    "Areas": List<dynamic>.from(areas.map((x) => x.toJson())),
    "Departments": List<dynamic>.from(departments.map((x) => x.toJson())),
  };
}

class Area {
  Area({
    this.areaId,
    this.zoneId,
    this.areaName,
  });

  int areaId;
  int zoneId;
  String areaName;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    areaId: json["AreaId"],
    zoneId: json["ZoneId"],
    areaName: json["AreaName"],
  );

  Map<String, dynamic> toJson() => {
    "AreaId": areaId,
    "ZoneId": zoneId,
    "AreaName": areaName,
  };
}

class Department {
  Department({
    this.departmentId,
    this.departmentName,
    this.departmentShortName,
  });

  int departmentId;
  String departmentName;
  String departmentShortName;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    departmentId: json["DepartmentId"],
    departmentName: json["DepartmentName"],
    departmentShortName: json["DepartmentShortName"],
  );

  Map<String, dynamic> toJson() => {
    "DepartmentId": departmentId,
    "DepartmentName": departmentName,
    "DepartmentShortName": departmentShortName,
  };
}

class ReportCategory {
  ReportCategory({
    this.reportCategoryId,
    this.reportCategoryName,
  });

  int reportCategoryId;
  String reportCategoryName;

  factory ReportCategory.fromJson(Map<String, dynamic> json) => ReportCategory(
    reportCategoryId: json["ReportCategoryId"],
    reportCategoryName: json["ReportCategoryName"],
  );

  Map<String, dynamic> toJson() => {
    "ReportCategoryId": reportCategoryId,
    "ReportCategoryName": reportCategoryName,
  };
}

class ReportType {
  ReportType({
    this.departmentId,
    this.departmentName,
    this.isPublic,
    this.priorityCode,
    this.reportCategoryId,
    this.reportTypeId,
    this.reportTypeName,
  });

  int departmentId;
  String departmentName;
  bool isPublic;
  String priorityCode;
  int reportCategoryId;
  int reportTypeId;
  String reportTypeName;

  factory ReportType.fromJson(Map<String, dynamic> json) => ReportType(
    departmentId: json["DepartmentId"],
    departmentName: json["DepartmentName"],
    isPublic: json["IsPublic"],
    priorityCode: json["PriorityCode"],
    reportCategoryId: json["ReportCategoryId"],
    reportTypeId: json["ReportTypeId"],
    reportTypeName: json["ReportTypeName"],
  );

  Map<String, dynamic> toJson() => {
    "DepartmentId": departmentId,
    "DepartmentName": departmentName,
    "IsPublic": isPublic,
    "PriorityCode": priorityCode,
    "ReportCategoryId": reportCategoryId,
    "ReportTypeId": reportTypeId,
    "ReportTypeName": reportTypeName,
  };
}

class Zone {
  Zone({
    this.zoneId,
    this.zoneName,
  });

  int zoneId;
  String zoneName;

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    zoneId: json["ZoneId"],
    zoneName: json["ZoneName"],
  );

  Map<String, dynamic> toJson() => {
    "ZoneId": zoneId,
    "ZoneName": zoneName,
  };
}