import 'package:flutter/material.dart';
import 'package:pkg_text_field/UI/suggest_textfield/database/databasehelper.dart';
import 'package:pkg_text_field/UI/view/screen/suggetion_api_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper helper = DatabaseHelper();
  Database? db;
  db = await helper.getDB();
  debugPrint('db : $db');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: SuggetionApiPage(),
    );
  }
}



