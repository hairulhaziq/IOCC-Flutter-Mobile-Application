// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

List<ReportModel> reportFromJson(String str) =>
    List<ReportModel>.from(json.decode(str).map((x) => ReportModel.fromJson(x)));

String reportToJson(List<ReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportModel {
  ReportModel({
    this.actionTakenDateTime,
    this.areaId,
    this.areaName,
    this.councilId,
    this.createdByAccount,
    this.createdByAccountId,
    this.createdDateTime,
    this.departmentId,
    this.departmentName,
    this.description,
    this.environmentId,
    this.estimatedLocation,
    this.isReportedFirst,
    this.isReporterUnreg,
    this.parentReportId,
    this.priorityCode,
    this.priorityName,
    this.referenceNo,
    this.remark,
    this.reportCategoryId,
    this.reportCategoryName,
    this.reportedByAccount,
    this.reportedByAccountId,
    this.reportFeeds,
    this.reportId,
    this.reportingModeIcon,
    this.reportingModeId,
    this.reportingModeName,
    this.reportStatusColorCode,
    this.reportStatusId,
    this.reportStatusLabel,
    this.reportStatusName,
    this.reportTypeId,
    this.reportTypeName,
    this.shapeWkt,
    this.supervisorAccountId,
    this.supervisorAccountFullName,
    this.accountRoleId,
    this.title,
    this.pushNotification,
    this.pushNotificationOk,
    this.reportedByUnregAccount,
    this.reportedByUnregAccountId,
    this.updatedByAccount,
    this.updatedByAccountId,
    this.updatedDateTime,
    this.userRating,
    this.zoneId,
    this.zoneName,
    this.maxRows,
    this.totalPageNo,
  });

  DateTime actionTakenDateTime;
  int areaId;
  String areaName;
  int councilId;
  TedByAccount createdByAccount;
  int createdByAccountId;
  DateTime createdDateTime;
  int departmentId;
  String departmentName;
  String description;
  int environmentId;
  String estimatedLocation;
  bool isReportedFirst;
  bool isReporterUnreg;
  int parentReportId;
  String priorityCode;
  String priorityName;
  String referenceNo;
  String remark;
  int reportCategoryId;
  String reportCategoryName;
  TedByAccount reportedByAccount;
  int reportedByAccountId;
  List<ReportFeed> reportFeeds;
  int reportId;
  ReportingModeIcon reportingModeIcon;
  int reportingModeId;
  String reportingModeName;
  String reportStatusColorCode;
  int reportStatusId;
  String reportStatusLabel;
  String reportStatusName;
  int reportTypeId;
  String reportTypeName;
  String shapeWkt;
  int supervisorAccountId;
  String supervisorAccountFullName;
  int accountRoleId;
  String title;
  dynamic pushNotification;
  dynamic pushNotificationOk;
  dynamic reportedByUnregAccount;
  dynamic reportedByUnregAccountId;
  TedByAccount updatedByAccount;
  int updatedByAccountId;
  DateTime updatedDateTime;
  dynamic userRating;
  int zoneId;
  String zoneName;
  int maxRows;
  int totalPageNo;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        actionTakenDateTime: json["ActionTakenDateTime"] == null
            ? null
            : DateTime.parse(json["ActionTakenDateTime"]),
        areaId: json["AreaId"] == null ? null : json["AreaId"],
        areaName: json["AreaName"],
        councilId: json["CouncilId"],
        createdByAccount: TedByAccount.fromJson(json["CreatedByAccount"]),
        createdByAccountId: json["CreatedByAccountId"],
        createdDateTime: DateTime.parse(json["CreatedDateTime"]),
        departmentId: json["DepartmentId"],
        departmentName: json["DepartmentName"],
        description: json["Description"],
        environmentId: json["EnvironmentId"],
        estimatedLocation: json["EstimatedLocation"],
        isReportedFirst: json["IsReportedFirst"],
        isReporterUnreg: json["IsReporterUnreg"],
        parentReportId: json["ParentReportId"],
        priorityCode:
            json["PriorityCode"] == null ? null : json["PriorityCode"],
        priorityName: json["PriorityName"],
        referenceNo: json["ReferenceNo"],
        remark: json["Remark"],
        reportCategoryId: json["ReportCategoryId"],
        reportCategoryName: json["ReportCategoryName"],
        reportedByAccount: TedByAccount.fromJson(json["ReportedByAccount"]),
        reportedByAccountId: json["ReportedByAccountId"],
        reportFeeds: List<ReportFeed>.from(
            json["ReportFeeds"].map((x) => ReportFeed.fromJson(x))),
        reportId: json["ReportId"],
        reportingModeIcon:
            reportingModeIconValues.map[json["ReportingModeIcon"]],
        reportingModeId: json["ReportingModeId"],
        reportingModeName: json["ReportingModeName"],
        reportStatusColorCode: json["ReportStatusColorCode"],
        reportStatusId: json["ReportStatusId"],
        reportStatusLabel: json["ReportStatusLabel"],
        reportStatusName: json["ReportStatusName"],
        reportTypeId: json["ReportTypeId"],
        reportTypeName: json["ReportTypeName"],
        shapeWkt: json["ShapeWKT"],
        supervisorAccountId: json["SupervisorAccountId"] == null
            ? null
            : json["SupervisorAccountId"],
        supervisorAccountFullName: json["SupervisorAccountFullName"] == null
            ? null
            : json["SupervisorAccountFullName"],
        accountRoleId: json["AccountRoleId"],
        title: json["Title"],
        pushNotification: json["PushNotification"],
        pushNotificationOk: json["PushNotificationOK"],
        reportedByUnregAccount: json["ReportedByUnregAccount"],
        reportedByUnregAccountId: json["ReportedByUnregAccountId"],
        updatedByAccount: TedByAccount.fromJson(json["UpdatedByAccount"]),
        updatedByAccountId: json["UpdatedByAccountId"],
        updatedDateTime: DateTime.parse(json["UpdatedDateTime"]),
        userRating: json["UserRating"],
        zoneId: json["ZoneId"] == null ? null : json["ZoneId"],
        zoneName: json["ZoneName"],
        maxRows: json["MaxRows"],
        totalPageNo: json["TotalPageNo"],
      );

  Map<String, dynamic> toJson() => {
        "ActionTakenDateTime": actionTakenDateTime == null
            ? null
            : actionTakenDateTime.toIso8601String(),
        "AreaId": areaId == null ? null : areaId,
        "AreaName": areaName,
        "CouncilId": councilId,
        "CreatedByAccount": createdByAccount,
        "CreatedByAccountId": createdByAccountId,
        "CreatedDateTime": createdDateTime.toIso8601String(),
        "DepartmentId": departmentId,
        "DepartmentName": departmentName,
        "Description": description,
        "EnvironmentId": environmentId,
        "EstimatedLocation": estimatedLocation,
        "IsReportedFirst": isReportedFirst,
        "IsReporterUnreg": isReporterUnreg,
        "ParentReportId": parentReportId,
        "PriorityCode": priorityCode == null ? null : priorityCode,
        "PriorityName": priorityName,
        "ReferenceNo": referenceNo,
        "Remark": remark,
        "ReportCategoryId": reportCategoryId,
        "ReportCategoryName": reportCategoryName,
        "ReportedByAccount": reportedByAccount,
        "ReportedByAccountId": reportedByAccountId,
        "ReportFeeds": List<dynamic>.from(reportFeeds.map((x) => x.toJson())),
        "ReportId": reportId,
        "ReportingModeIcon": reportingModeIcon,
        "ReportingModeId": reportingModeId,
        "ReportingModeName": reportingModeName,
        "ReportStatusColorCode": reportStatusColorCode,
        "ReportStatusId": reportStatusId,
        "ReportStatusLabel": reportStatusLabel,
        "ReportStatusName": reportStatusName,
        "ReportTypeId": reportTypeId,
        "ReportTypeName": reportTypeName,
        "ShapeWKT": shapeWkt,
        "SupervisorAccountId":
            supervisorAccountId == null ? null : supervisorAccountId,
        "SupervisorAccountFullName": supervisorAccountFullName == null
            ? null
            : supervisorAccountFullName,
        "AccountRoleId": accountRoleId,
        "Title": title,
        "PushNotification": pushNotification,
        "PushNotificationOK": pushNotificationOk,
        "ReportedByUnregAccount": reportedByUnregAccount,
        "ReportedByUnregAccountId": reportedByUnregAccountId,
        "UpdatedByAccount": updatedByAccount,
        "UpdatedByAccountId": updatedByAccountId,
        "UpdatedDateTime": updatedDateTime.toIso8601String(),
        "UserRating": userRating,
        "ZoneId": zoneId == null ? null : zoneId,
        "ZoneName": zoneName,
        "MaxRows": maxRows,
        "TotalPageNo": totalPageNo,
      };
}

class TedByAccount {
  TedByAccount({
    this.accountId,
    this.accountName,
    this.address,
    this.avatarFileName,
    this.contactNumber,
    this.emailAddress,
    this.userId,
  });

  int accountId;
  String accountName;
  String address;
  AvatarFileName avatarFileName;
  String contactNumber;
  String emailAddress;
  int userId;

  factory TedByAccount.fromJson(Map<String, dynamic> json) => TedByAccount(
        accountId: json["AccountId"],
        accountName: json["AccountName"],
        address: json["Address"],
        avatarFileName: json["AvatarFileName"] == null
            ? null
            : avatarFileNameValues.map[json["AvatarFileName"]],
        contactNumber: json["ContactNumber"],
        emailAddress: json["EmailAddress"],
        userId: json["UserId"],
      );

  Map<String, dynamic> toJson() => {
        "AccountId": accountId,
        "AccountName": accountName,
        "Address": address,
        "AvatarFileName": avatarFileName == null
            ? null
            : avatarFileNameValues.reverse[avatarFileName],
        "ContactNumber": contactNumber,
        "EmailAddress": emailAddress,
        "UserId": userId,
      };
}

enum AvatarFileName { AVATAR_PNG }

final avatarFileNameValues =
    EnumValues({"avatar.png": AvatarFileName.AVATAR_PNG});

enum DepartmentName { UNIT_TRAFIK }

final departmentNameValues =
    EnumValues({"Unit Trafik": DepartmentName.UNIT_TRAFIK});

enum PriorityName { TIDAK_DIKETAHUI, RENDAH }

final priorityNameValues = EnumValues({
  "RENDAH": PriorityName.RENDAH,
  "TIDAK DIKETAHUI": PriorityName.TIDAK_DIKETAHUI
});

enum ReportCategoryName { PELAPORAN, HALANGAN }

final reportCategoryNameValues = EnumValues({
  "Halangan": ReportCategoryName.HALANGAN,
  "Pelaporan": ReportCategoryName.PELAPORAN
});

class ReportFeed {
  ReportFeed({
    this.comment,
    this.createdByAccountId,
    this.createdByAccount,
    this.createdDateTime,
    this.mediaFileName,
    this.mediaTypeId,
    this.reportFeedId,
    this.reportId,
    this.reportStatusId,
    this.reportStatusName,
  });

  dynamic comment;
  dynamic createdByAccountId;
  TedByAccount createdByAccount;
  DateTime createdDateTime;
  String mediaFileName;
  int mediaTypeId;
  int reportFeedId;
  int reportId;
  int reportStatusId;
  String reportStatusName;

  factory ReportFeed.fromJson(Map<String, dynamic> json) => ReportFeed(
        comment: json["Comment"],
        createdByAccountId: json["CreatedByAccountId"],
        createdByAccount: TedByAccount.fromJson(json["CreatedByAccount"]),
        createdDateTime: DateTime.parse(json["CreatedDateTime"]),
        mediaFileName: json["MediaFileName"],
        mediaTypeId: json["MediaTypeId"],
        reportFeedId: json["ReportFeedId"],
        reportId: json["ReportId"],
        reportStatusId: json["ReportStatusId"],
        reportStatusName: json["ReportStatusName"],
      );

  Map<String, dynamic> toJson() => {
        "Comment": comment,
        "CreatedByAccountId": createdByAccountId,
        "CreatedByAccount": createdByAccount.toJson(),
        "CreatedDateTime": createdDateTime.toIso8601String(),
        "MediaFileName": mediaFileName,
        "MediaTypeId": mediaTypeId,
        "ReportFeedId": reportFeedId,
        "ReportId": reportId,
        "ReportStatusId": reportStatusId,
        "ReportStatusName": reportStatusName,
      };
}

enum ReportingModeIcon { MOBILE, VIDEO_CAMERA }

final reportingModeIconValues = EnumValues({
  "mobile": ReportingModeIcon.MOBILE,
  "video-camera": ReportingModeIcon.VIDEO_CAMERA
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
