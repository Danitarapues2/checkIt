import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore db = FirebaseFirestore.instance;
Future<List> getCliente() async {
  List cliente = [];
  CollectionReference collectionReferenceCliente = db.collection("create");
  QuerySnapshot queryCliente = await collectionReferenceCliente.get();

  queryCliente.docs.forEach((documento) {
    cliente.add(documento.data());
  });
  return cliente; 
}

Future<List> getUsuarios() async {
  List cliente = [];
  CollectionReference collectionReferenceCliente = db.collection("usuario");
  QuerySnapshot queryCliente = await collectionReferenceCliente.get();

  queryCliente.docs.forEach((documento) {
    cliente.add(documento.data());
  });
  return cliente; 
}

Future<List> getLista() async {
  List listaTareas = [];
  CollectionReference collectionReferenceListaTareas = db.collection("listas");
  QuerySnapshot queryListaTareas = await collectionReferenceListaTareas.get();

  for (var documento in queryListaTareas.docs) {
    var data = documento.data() as Map<String, dynamic>;
    data['id'] = documento.id;  // Incluye el ID del documento para futuras referencias
    listaTareas.add(data);
  }
  return listaTareas; 
}