import 'package:c4ivc_flutter/screens/Login.dart';
import 'package:c4ivc_flutter/screens/Splash.dart';
import 'package:c4ivc_flutter/utils/ChangeValueNotifier.dart';
import 'package:c4ivc_flutter/utils/Globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Env>.value(value: Env.Staging),
        Provider<AppPlatform>.value(value: AppPlatform.Android),
        ChangeNotifierProvider<ChangeValueNotifier>.value(value: ChangeValueNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Template',
        home: Splash(),
      ),
    );
  }
}
