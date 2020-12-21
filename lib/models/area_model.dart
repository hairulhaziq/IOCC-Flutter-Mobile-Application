import 'dart:convert';

List<AreaModel> areaFromJson(String str) =>
    List<AreaModel>.from(json.decode(str).map((x) => AreaModel.fromJson(x)));

String areaToJson(List<AreaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AreaModel {
  AreaModel({
    this.areaId,
    this.zoneId,
    this.areaName,
  });

  int areaId;
  int zoneId;
  String areaName;

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
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
