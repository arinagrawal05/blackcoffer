import 'package:blackcoffer/Boarding/Screens/enter_phone.dart';
import 'package:blackcoffer/Boarding/Provider/auth_provider.dart';
import 'package:blackcoffer/Vedio/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AuthProvider(),
            ),
          ],
          builder: (context, _) {
            return GetMaterialApp(
              title: 'Blackcoffer',
              home: EnterPhonepage(),
              debugShowCheckedModeBanner: false,
            );
          });
}
