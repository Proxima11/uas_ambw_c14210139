//Kristofer Steven - C14210139
//UAS-AMBW

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pin_screen.dart';
// import 'notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('PIN');
  if (!Hive.isBoxOpen('notes')) {
    await Hive.openBox<Map>('notes');
  }

  // if (!Hive.isBoxOpen('settings')) {
  //   await Hive.openBox('settings');
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taking App',
      home: PinScreen(),
    );
  }
}
