import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:youhealth/screens/dashboard.dart';
import 'package:youhealth/screens/login.dart'; // Asegúrate de que esta ruta de importación sea correcta
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Inicialización del plugin de notificaciones locales
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inicialización de la zona horaria
  tz.initializeTimeZones();

  // Verificar si el usuario está conectado
  auth.User? user = auth.FirebaseAuth.instance.currentUser;

  runApp(MainApp(user: user));
}

class MainApp extends StatelessWidget {
  final auth.User? user;

  const MainApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: user != null ? Dashboard() : LoginPage(),
    );
  }
}