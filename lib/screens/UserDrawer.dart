import 'package:c4ivc_flutter/screens/About.dart';
import 'package:c4ivc_flutter/screens/Login.dart';
import 'package:c4ivc_flutter/screens/UserGuide.dart';
import 'package:c4ivc_flutter/screens/UserProfile.dart';
import 'package:c4ivc_flutter/utils/ChangeValueNotifier.dart';
import 'package:c4ivc_flutter/utils/Globals.dart';
import 'package:c4ivc_flutter/utils/SizeConfig.dart';
import 'package:c4ivc_flutter/widgets/Password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDrawer extends StatelessWidget {
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', '');
    prefs.setString('password', '');
//    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
//    final CounterBloc counterBloc = Provider.of<CounterBloc>(context);
    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: AssetImage('assets/img/background/drawer_mpsj.jpg'),
                ),
                color: Colors.black,
              ),
              accountName: Text(
                Globals.userAccount.accountFullName ?? '',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                ),
              ),
              accountEmail: Text(
                Globals.userAccount.identificationNumber ?? '',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://115.133.238.21/img/accounts/96/${Globals.userAccount.avatarFileName}')),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.key),
              title: Text('Tukar Katalaluan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.newspaper),
              title: Text('Panduan Pengguna'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserGuide()),
                );
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.infoCircle),
              title: Text('Tentang Aplikasi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
            ),
            Divider(
              thickness: 1,
            ),
            Expanded(
              child: ListTile(
                leading: Icon(FontAwesomeIcons.reply),
                title: Text('Log keluar'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                  addStringToSF();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
