import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youhealth/screens/login.dart'; // Asegúrate de que esta ruta de importación sea correcta

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(), // Cambia esto a LoginPage()
    );
  }
}