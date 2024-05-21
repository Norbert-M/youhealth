
import 'package:firebase_auth_rest/firebase_auth_rest.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  void signIn() async {
    try {
      final auth = FirebaseAuth(
        apiKey: 'your-api-key', // Reemplaza esto con tu clave de API de Firebase
        authDomain: 'your-auth-domain', // Reemplaza esto con tu dominio de autenticación de Firebase
      );
      final response = await auth.signInWithPassword(
        emailController.text,
        passwordController.text,
      );
      // Usuario autenticado con éxito
    } on Exception catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text('Iniciar sesión'),
              onPressed: signIn,
            ),
          ],
        ),
      ),
    );
  }
}