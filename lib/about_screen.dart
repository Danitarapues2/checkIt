import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/images/fondo.jpg'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover, // Ajuste de la imagen
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('/images/icon.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'CheckIt',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), 
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Versión 1.0.0',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 86, 86, 86),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Esta es una aplicación diseñada para ayudarte a gestionar tus tareas diarias de manera eficiente. Con una interfaz intuitiva y funciones avanzadas, puedes organizar tus tareas y mantener un seguimiento de tu progreso fácilmente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0), // Cambia el color del texto si es necesario para mejorar la legibilidad
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
