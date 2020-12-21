import 'package:c4ivc_flutter/models/user_account_model.dart';
import 'package:c4ivc_flutter/utils/SocketUtils.dart';

enum Env { Development, Staging, Production }
enum AppPlatform { Android, iOS }

class Globals {
  static String secretLCAD =
      "92836A22716A9FC822F0F904B16B888E8BAE3A8A96F24B56B8CA06546D9ED186";

  //IP and Port
  static String restPortNo = "7890"; //Rest port No

//  static String portSocketIO = "3000"; //SocketIO PortNo
//  static String ipPublic = "175.250.189.201"; //SCS server public IP

  //C4IVC
  // static String portSocketIO = "3002"; //SocketIO PortNo
  // static String ipPublic = "175.138.60.122"; //SCS server public IP

  // IOCC
  static String portSocketIO = "3003"; //SocketIO PortNo
  static String ipPublic = "115.133.238.21"; //SCS server public IP
  static String ipPrivate = "192.168.116.41"; //SCS server public IP


  //SocketIO and REST URL
  static String rootSocketIO = "http://" + ipPublic + ":" + portSocketIO + "/";
  static String rootSocketIO_2 = "http://" + ipPrivate + ":" + portSocketIO + "/";
  static String rootURLRest = "http://" + ipPublic + ":" + restPortNo + "/api/";

  static UserAccountModel userAccount;

  static SocketUtils socketUtils;

  static String sendInterval = '5';
}
