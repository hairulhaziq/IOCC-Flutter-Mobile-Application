// To parse this JSON data, do
//
//     final userAccount = userAccountFromJson(jsonString);

import 'dart:convert';

UserAccountModel userAccountFromJson(String str) =>
    UserAccountModel.fromJson(json.decode(str));

String userAccountToJson(UserAccountModel data) => json.encode(data.toJson());

class UserAccountModel {
  UserAccountModel({
    this.aboutAccount,
    this.accountCode,
    this.accountFullName,
    this.accountId,
    this.accountProfileName,
    this.accountRoleId,
    this.accountTypeId,
    this.address,
    this.authenticationStatusId,
    this.avatarFileName,
    this.contactNumber,
    this.contractorId,
    this.councilId,
    this.coverPhotoFileName,
    this.createdByAccountId,
    this.createdDateTime,
    this.departmentId,
    this.emailAddress,
    this.facebookAccount,
    this.faxNumber,
    this.googlePlusAccount,
    this.identificationNumber,
    this.password,
    this.tagLine,
    this.twitterAccount,
    this.updatedDateTime,
    this.userId,
    this.webSite,
    this.zoneId,
    this.shapeWkt,
    this.dateTimeIn,
  });

  dynamic aboutAccount;
  String accountCode;
  String accountFullName;
  int accountId;
  String accountProfileName;
  int accountRoleId;
  int accountTypeId;
  String address;
  int authenticationStatusId;
  String avatarFileName;
  String contactNumber;
  dynamic contractorId;
  int councilId;
  String coverPhotoFileName;
  dynamic createdByAccountId;
  DateTime createdDateTime;
  int departmentId;
  String emailAddress;
  dynamic facebookAccount;
  String faxNumber;
  dynamic googlePlusAccount;
  dynamic identificationNumber;
  dynamic password;
  dynamic tagLine;
  dynamic twitterAccount;
  dynamic updatedDateTime;
  int userId;
  dynamic webSite;
  dynamic zoneId;
  dynamic shapeWkt;
  dynamic dateTimeIn;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) => UserAccountModel(
        aboutAccount: json["AboutAccount"],
        accountCode: json["AccountCode"],
        accountFullName: json["AccountFullName"],
        accountId: json["AccountId"],
        accountProfileName: json["AccountProfileName"],
        accountRoleId: json["AccountRoleId"],
        accountTypeId: json["AccountTypeId"],
        address: json["Address"],
        authenticationStatusId: json["AuthenticationStatusId"],
        avatarFileName: json["AvatarFileName"],
        contactNumber: json["ContactNumber"],
        contractorId: json["ContractorId"],
        councilId: json["CouncilId"],
        coverPhotoFileName: json["CoverPhotoFileName"],
        createdByAccountId: json["CreatedByAccountId"],
        createdDateTime: DateTime.parse(json["CreatedDateTime"]),
        departmentId: json["DepartmentId"],
        emailAddress: json["EmailAddress"],
        facebookAccount: json["FacebookAccount"],
        faxNumber: json["FaxNumber"],
        googlePlusAccount: json["GooglePlusAccount"],
        identificationNumber: json["IdentificationNumber"],
        password: json["Password"],
        tagLine: json["TagLine"],
        twitterAccount: json["TwitterAccount"],
        updatedDateTime: json["UpdatedDateTime"],
        userId: json["UserId"],
        webSite: json["WebSite"],
        zoneId: json["ZoneId"],
        shapeWkt: json["ShapeWKT"],
        dateTimeIn: json["DateTimeIn"],
      );

  Map<String, dynamic> toJson() => {
        "AboutAccount": aboutAccount,
        "AccountCode": accountCode,
        "AccountFullName": accountFullName,
        "AccountId": accountId,
        "AccountProfileName": accountProfileName,
        "AccountRoleId": accountRoleId,
        "AccountTypeId": accountTypeId,
        "Address": address,
        "AuthenticationStatusId": authenticationStatusId,
        "AvatarFileName": avatarFileName,
        "ContactNumber": contactNumber,
        "ContractorId": contractorId,
        "CouncilId": councilId,
        "CoverPhotoFileName": coverPhotoFileName,
        "CreatedByAccountId": createdByAccountId,
        "CreatedDateTime": createdDateTime.toIso8601String(),
        "DepartmentId": departmentId,
        "EmailAddress": emailAddress,
        "FacebookAccount": facebookAccount,
        "FaxNumber": faxNumber,
        "GooglePlusAccount": googlePlusAccount,
        "IdentificationNumber": identificationNumber,
        "Password": password,
        "TagLine": tagLine,
        "TwitterAccount": twitterAccount,
        "UpdatedDateTime": updatedDateTime,
        "UserId": userId,
        "WebSite": webSite,
        "ZoneId": zoneId,
        "ShapeWKT": shapeWkt,
        "DateTimeIn": dateTimeIn,
      };
}
