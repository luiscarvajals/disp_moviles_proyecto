import 'package:cloud_firestore/cloud_firestore.dart';

class Grabacion{
  String _id;
  String _titulo;
  String _materia;
  Timestamp _fecha;
  String _ruta;

  Grabacion(this._id, this._titulo, this._materia, this._fecha, this._ruta);

  String get ruta => _ruta;

  set ruta(String value) {
    _ruta = value;
  }

  Timestamp get fecha => _fecha;

  set fecha(Timestamp value) {
    _fecha = value;
  }

  String get materia => _materia;

  set materia(String value) {
    _materia = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  crearGrabacion() async {
    await FirebaseFirestore.instance.collection('grabaciones').add({
      'titulo': titulo,
      'materia': materia,
      'fecha': fecha,
      'ruta': ruta,
    }).then((value){
      print(value.id);
    });
  }
}