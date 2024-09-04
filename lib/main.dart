import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upsets/Screens/splash_screen.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserdatamodelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(ProfileModelAdapter());

  await Hive.openBox<Userdatamodel>('create_account');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenSplash(),
    );
  }
}
