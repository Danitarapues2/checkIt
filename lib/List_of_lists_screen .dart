import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:check_it/task_lists_creen.dart';

class ListOfListsScreen extends StatelessWidget {
  const ListOfListsScreen({Key? key});

  Future<void> deleteList(BuildContext context, String listId) async {
    try {
      await FirebaseFirestore.instance.collection("listas").doc(listId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La lista ha sido eliminada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la lista: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/images/fondo.jpg'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover, // Ajuste de la imagen
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getLista(),
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay listas disponibles.'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (context, index) {
                  if (index == snapshot.data!.length) {
                    // Último elemento es el botón para agregar lista
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      color: Color.fromARGB(255, 243, 242, 242),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/addList');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add, size: 40),
                              SizedBox(height: 8),
                              Text('Agregar Lista', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    final lista = snapshot.data![index];
                    return Dismissible(
                      key: Key(lista['id']), // Usamos el ID como clave para el Dismissible
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        deleteList(context, lista['id']);
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Eliminar lista'),
                              content: const Text('¿Estás seguro de que deseas eliminar esta lista?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        child: Card(
                          color: Color.fromARGB(255, 238, 238, 238),
                          child: ListTile(
                            title: Text(lista['title']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskListScreen(
                                    listId: lista['id'],
                                    listTitle: lista['title'],
                                    tasks: List<String>.from(lista['tasks']),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getLista() async {
  List<Map<String, dynamic>> listaTareas = [];
  try {
    CollectionReference collectionReferenceListaTareas = FirebaseFirestore.instance.collection("listas");
    QuerySnapshot queryListaTareas = await collectionReferenceListaTareas.get();

    for (var documento in queryListaTareas.docs) {
      var data = documento.data() as Map<String, dynamic>;
      data['id'] = documento.id;
      listaTareas.add(data);
    }
  } catch (e) {
    // Manejo de errores
    print('Error al obtener la lista de tareas: $e');
  }
  return listaTareas;
}
