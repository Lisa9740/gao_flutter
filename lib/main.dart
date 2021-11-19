import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gao_flutter/utils/shared_pref.dart';

import 'package:gao_flutter/view/home.dart';
import 'package:gao_flutter/view/login.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget renderPage() {
    var token = sharedPref().read("token");
    if (token != null){
      return HomePage();
    }
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr')
        ],
        debugShowCheckedModeBanner: false,
        title: 'GAO flutter',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: renderPage());
  }


}
