import 'dart:convert';
import 'package:crypto/crypto.dart';

//import 'package:fealm/commons/StringBuilder.dart';
//import 'package:fealm/fealm/Fealm.dart';

/*
  How to use :

  print(MD5Hashing.createPasswordHash("mpsj_utt1_1"));

  Result:
  username : mpsj_utt1_1
  password : 11ee7f3929cae823841c978c79e5c7ce41a2cd73

  username : mpsj_op2_1
  password : 9fa9c022ef40bfdc52749932821df067cdc2b811

  username : mpsj_utt4_2
  password : bdf2e8903f81312372e8087a3e1c6927eaef6ab4
 */

class MD5Hashing {
  static String _passwordSecret = "E-Majlis";
  static String _passwordSalt = "2015";

  static String createPasswordHash(String password) {
    return _generateSHA1Hash(
        _generateMD5Hash(_passwordSecret + password) + _passwordSalt);
  }

  static String _generateMD5Hash(String password) {
    List<int> byteMD5 = utf8.encode(password);
//    print("byteMD5 =" + byteMD5.toString());
    Digest byteHashed = md5.convert(byteMD5);
    //print("byteHashed (byteMD5) =" + byteHashed.toString());
    return byteHashed.toString();
  }

  static String _generateSHA1Hash(String md5Password) {
    List<int> byteSHA1 = utf8.encode(md5Password);
//    print("byteSHA1=" + byteSHA1.toString());
    Digest byteHashed = sha1.convert(byteSHA1);
//    print("byteSHA1 (byteHashed) =" + byteHashed.toString());

    return byteHashed.toString();
  }
}
