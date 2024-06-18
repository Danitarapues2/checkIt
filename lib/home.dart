import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:check_it/menu_drawer.dart';

class Home extends StatelessWidget {
  final User user;

  const Home({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: DrawerMenu(userEmail: user.email ?? 'Usuario anónimo'), // Pasa el email del usuario al DrawerMenu
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/images/fondo.jpg'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover, // Ajuste de la imagen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Mensaje de bienvenida personalizado con animación de opacidad
              TweenAnimationBuilder(
                duration: const Duration(seconds: 4),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (BuildContext context, double value, Widget? child) {
                  return Opacity(
                    opacity: value,
                    child: Column(
                      children: [
                        Text(
                          '¡Bienvenido a CheckIt!',
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Organiza tus tareas fácilmente, ${user.email ?? 'Usuario anónimo'}.',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/addList');
                          },
                          child: Text(
                            'Empieza a crear tu lista de tareas ahora.',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 69, 69, 69), // Cambia el color del enlace aquí
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
