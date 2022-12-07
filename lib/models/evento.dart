import 'package:cloud_firestore/cloud_firestore.dart';

class Evento{
  String _id;
  String _titulo;
  Timestamp _fecha;
  String _nota;
  bool _terminado;

  Evento(this._id, this._titulo, this._fecha, this._nota, this._terminado);


  bool get terminado => _terminado;

  set terminado(bool value) {
    _terminado = value;
  }

  String get nota => _nota;

  set nota(String value) {
    _nota = value;
  }

  Timestamp get fecha => _fecha;

  set fecha(Timestamp value) {
    _fecha = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  crearEvento() async {
    await FirebaseFirestore.instance.collection('eventos').add({
      'titulo': titulo,
      'fecha': fecha,
      'nota': nota,
      'terminado': terminado
    }).then((value){
      print(value.id);
    });
  }
}