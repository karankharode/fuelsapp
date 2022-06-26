// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelsapp/modules/Auth/SplashScreen/views/SplashScreen.dart';
import 'package:provider/provider.dart';

import 'modules/Auth/Login/controller/LoginController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    Provider<LoginController>(create: (_) => LoginController()),
  ], child: const MyApp()
      //  DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(), // Wrap your app
      // ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoSmart',
      theme: ThemeData(
        fontFamily: 'Product Sans',
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),
    );
  }
}
