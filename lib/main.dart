import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:youhealth/routes/AppRoutes.dart';
import 'package:youhealth/screens/dashboard.dart';
import 'package:youhealth/screens/historial.dart';
import 'package:youhealth/screens/login.dart'; // Asegúrate de que esta ruta de importación sea correcta
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:youhealth/screens/perfil.dart';
import 'package:youhealth/screens/principal.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initializeNotifications();

  
  // Inicialización del plugin de notificaciones locales
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = const InitializationSettings(
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

      routes: {
    AppRoutes.principal: (context) => PrincipalPage(),
    AppRoutes.historial: (context) => HistorialPage(),
    AppRoutes.perfil: (context) => PerfilPage(),
    // Agrega más rutas aquí
  },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Cambia el color de todos los íconos de la barra de aplicaciones a blanco
          ),
        ),
      ),
      home: user != null ? Dashboard() : LoginPage(),
    );
  }
}