import 'package:check_it/List_of_lists_screen%20.dart';
import 'package:check_it/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:check_it/about_screen.dart';
import 'package:check_it/add_task_screen.dart';
import 'package:check_it/home.dart';
import 'package:check_it/auth/login_screen.dart';
import 'package:check_it/auth/auth_service.dart'; // Importa el servicio de autenticación

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
      routes: {
        '/taskList': (context) => const ListOfListsScreen(),
        '/addList': (context) => const AddTaskScreen(),
        '/about': (context) => const AboutScreen(),
        '/register': (context) => RegisterScreen(authService: AuthService()),
        '/login': (context) => LoginScreen(authService: AuthService()),
        '/home': (context) => Home(user: FirebaseAuth.instance.currentUser!),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Indicador de carga
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            // Usuario autenticado, muestra la pantalla de inicio de sesión
            return LoginScreen(authService: AuthService());
          } else {
            // Usuario no autenticado, muestra la pantalla de inicio de sesión
            return LoginScreen(authService: AuthService());
          }
        }
      },
    );
  }
}