import 'package:fireapp/pages/auth_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //to shop list
  await Hive.initFlutter();
  await Hive.openBox("TODOCRUDHIVE");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
