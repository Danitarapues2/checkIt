import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListScreen extends StatefulWidget {
  final String listId;
  final String listTitle;
  final List<String> tasks;

  const TaskListScreen({
    required this.listId,
    required this.listTitle,
    required this.tasks,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Map<String, dynamic>> tasks;
  late String listTitle;

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks
        .map((task) => {'title': task, 'completed': false})
        .toList();
    listTitle = widget.listTitle;
  }

  Future<void> addTask(String task) async {
    setState(() {
      tasks.add({'title': task, 'completed': false});
    });
    await FirebaseFirestore.instance
        .collection('listas')
        .doc(widget.listId)
        .update({'tareas': tasks});
  }

  Future<void> deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
    });
    await FirebaseFirestore.instance
        .collection('listas')
        .doc(widget.listId)
        .update({'tareas': tasks});
  }

  Future<void> editTask(int index, String currentTask) async {
    String editedTask = currentTask;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar tarea'),
          content: TextField(
            onChanged: (value) {
              editedTask = value;
            },
            controller: TextEditingController(text: currentTask),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  tasks[index]['title'] = editedTask;
                });
                await FirebaseFirestore.instance
                    .collection('listas')
                    .doc(widget.listId)
                    .update({'tareas': tasks});
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editListTitle() async {
    String newTitle = listTitle;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar título de la lista'),
          content: TextField(
            onChanged: (value) {
              newTitle = value;
            },
            controller: TextEditingController(text: listTitle),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await updateListTitle(newTitle);
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateListTitle(String newTitle) async {
    setState(() {
      listTitle = newTitle;
    });
    await FirebaseFirestore.instance
        .collection('listas')
        .doc(widget.listId)
        .update({'title': newTitle, 'tareas': tasks});
  }

  Future<void> deleteList() async {
    try {
      await FirebaseFirestore.instance
          .collection('listas')
          .doc(widget.listId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La lista ha sido eliminada')),
      );

      Navigator.of(context).pushNamed('/taskList');
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
        title: Text(listTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: editListTitle,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Eliminar lista'),
                    content: const Text(
                        '¿Estás seguro de que deseas eliminar esta lista?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteList();
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/taskList');
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                '/images/fondo.jpg'), // Asegúrate de que la ruta sea correcta
            fit: BoxFit.cover, // Ajuste de la imagen
          ),
        ),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Container(
              color: const Color.fromARGB(
                  172, 255, 255, 255), // Fondo blanco para cada tarea
              child: ListTile(
                title: Text(task['title']),
                leading: Checkbox(
                  value: task['completed'],
                  onChanged: (value) {
                    setState(() {
                      tasks[index]['completed'] = value!;
                    });
                    FirebaseFirestore.instance
                        .collection('listas')
                        .doc(widget.listId)
                        .update({'tareas': tasks});
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editTask(index, task['title']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteTask(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTask = '';
              return AlertDialog(
                title: Text('Añadir nueva tarea'),
                content: TextField(
                  onChanged: (value) {
                    newTask = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (newTask.isNotEmpty) {
                        addTask(newTask);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Añadir'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
