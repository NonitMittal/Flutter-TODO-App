import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/add_item_page.dart';
import 'package:todo_app/Screens/login_page.dart';
import 'package:todo_app/Screens/my_homepage.dart';
import 'package:todo_app/Screens/sign_up_page.dart';
import 'package:todo_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        MyHomePage.id: (context) => const MyHomePage(title: "Flutter ToDo App"),
        AddItemPage.id: (context) => const AddItemPage(),
        LoginPage.id: (context) => const LoginPage(),
        SignUpPage.id: (context) => const SignUpPage(),
      },
      initialRoute: MyHomePage.id,
    );
  }
}