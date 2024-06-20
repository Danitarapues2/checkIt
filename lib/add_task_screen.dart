import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _taskControllers = [TextEditingController()];

  void _addTaskField() {
    setState(() {
      _taskControllers.add(TextEditingController());
    });
  }

  void _removeTaskField(int index) {
    setState(() {
      if (_taskControllers.length > 2) {
        _taskControllers.removeAt(index);
      }
    });
  }

  Future<void> _saveTaskList() async {
    if (_titleController.text.isEmpty) {
      _showErrorDialog('Por favor, ingrese el nombre de la lista.');
      return;
    }

    int tasksFilledCount = 0;
    List<String> tasks = [];

    for (var controller in _taskControllers) {
      if (controller.text.isNotEmpty) {
        tasks.add(controller.text);
        tasksFilledCount++;
      }
    }

    if (tasksFilledCount < 2) {
      _showErrorDialog('Por favor, ingrese al menos 2 tareas.');
      return;
    }

    try {
      // Acceder a la colección 'taskLists' en Firestore y guardar los datos
      await FirebaseFirestore.instance.collection('listas').add({
        'title': _titleController.text,
        'tasks': tasks,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lista de tareas guardada correctamente.'),
        ),
      );

      _titleController.clear();
      for (var controller in _taskControllers) {
        controller.clear();
      }

      // Navegar a la ruta /taskList
      Navigator.of(context).pushNamed('/taskList');

    } catch (e) {
      _showErrorDialog('Error al guardar la lista de tareas: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar lista de tareas',
          style: TextStyle(
            fontSize: 20.0,
            color: Color.fromARGB(255, 83, 83, 83),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/images/fondo.jpg'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover, // Ajuste de la imagen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Divider(height: 12.0,),
              const SizedBox(height: 20),
            TextField(
  controller: _titleController,
  decoration: const InputDecoration(
    labelText: 'Nombre de la lista',
    labelStyle: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255), // Cambia el color del texto del label si es necesario
    ),
    )),
               const Divider(height: 12.0, ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _taskControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _taskControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Tarea ${index + 1}',
                                filled: true,
                                fillColor: Color.fromARGB(235, 233, 233, 233).withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              _removeTaskField(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTaskField,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Agregar una tarea'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTaskList,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Guardar lista de tareas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
