import 'dart:convert';

List<ZoneTypeModel> zoneTypeFromJson(String str) =>
    List<ZoneTypeModel>.from(json.decode(str).map((x) => ZoneTypeModel.fromJson(x)));

String zoneTypeToJson(List<ZoneTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ZoneTypeModel {
  ZoneTypeModel({
    this.zoneName,
    this.reportTypeName,
    this.reportTypeId,
    this.zoneId,
  });

  String zoneName;
  String reportTypeName;
  int reportTypeId;
  int zoneId;

  factory ZoneTypeModel.fromJson(Map<String, dynamic> json) => ZoneTypeModel(
        zoneName: json["ZoneName"],
        reportTypeName: json["ReportTypeName"],
        reportTypeId: json["ReportTypeId"],
        zoneId: json["ZoneId"],
      );

  Map<String, dynamic> toJson() => {
        "ZoneName": zoneName,
        "ReportTypeName": reportTypeName,
        "ReportTypeId": reportTypeId,
        "ZoneId": zoneId,
      };
}
