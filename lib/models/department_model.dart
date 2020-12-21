// To parse this JSON data, do
//
//     final departments = departmentsFromJson(jsonString);

import 'dart:convert';

DepartmentModel departmentsFromJson(String str) => DepartmentModel.fromJson(json.decode(str));

String departmentsToJson(DepartmentModel data) => json.encode(data.toJson());

class DepartmentModel {
  DepartmentModel({
    this.reportCategories,
    this.reportTypes,
    this.zones,
    this.areas,
    this.departments,
  });

  List<dynamic> reportCategories;
  List<dynamic> reportTypes;
  List<dynamic> zones;
  List<dynamic> areas;
  List<Department> departments;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
    reportCategories: List<dynamic>.from(json["ReportCategories"].map((x) => x)),
    reportTypes: List<dynamic>.from(json["ReportTypes"].map((x) => x)),
    zones: List<dynamic>.from(json["Zones"].map((x) => x)),
    areas: List<dynamic>.from(json["Areas"].map((x) => x)),
    departments: List<Department>.from(json["Departments"].map((x) => Department.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ReportCategories": List<dynamic>.from(reportCategories.map((x) => x)),
    "ReportTypes": List<dynamic>.from(reportTypes.map((x) => x)),
    "Zones": List<dynamic>.from(zones.map((x) => x)),
    "Areas": List<dynamic>.from(areas.map((x) => x)),
    "Departments": List<dynamic>.from(departments.map((x) => x.toJson())),
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
