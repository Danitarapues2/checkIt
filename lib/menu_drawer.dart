import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final String userEmail;

  const DrawerMenu({required this.userEmail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              const CircleAvatar(
                radius: 35.0,
                backgroundImage: AssetImage('images/icon.png'),
              ),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(221, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Tus Listas'),
            onTap: () {
              Navigator.pop(context); // Cerrar el menú
              Navigator.pushNamed(context, '/taskList'); // Ir a la lista de tareas
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Agregar Lista'),
            onTap: () {
              Navigator.pop(context); // Cerrar el menú
              Navigator.pushNamed(context, '/addList'); // Ir a la pantalla de agregar lista
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            onTap: () {
              Navigator.pop(context); // Cerrar el menú
              Navigator.pushNamed(context, '/about'); // Ir a la pantalla de información sobre la aplicación
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () async {
              // Aquí implementa el cierre de sesión si es necesario
              Navigator.pop(context); // Cerrar el menú
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // Ir a la pantalla de login y eliminar el stack de navegación
            },
          ),
        ],
      ),
    );
  }
}
