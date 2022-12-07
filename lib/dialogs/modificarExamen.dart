import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/models/examen.dart';

dialogModificarExamen(BuildContext context, String id, String titulo, String materia, DateTime fechaLlega, String nota){

  Timestamp fechaUniversal = Timestamp.fromDate(fechaLlega);

  final tecTitulo = TextEditingController();
  final tecMateria = TextEditingController();
  final tecNota = TextEditingController();

  tecTitulo.text = titulo;
  tecMateria.text = materia;
  tecNota.text = nota;

  Widget cancelButton = TextButton(
    child: Text('Cancelar'),
    onPressed: () {
      Navigator.of(context).pop(); // cierra el dialog
    },
  );

  Widget confirmButton = TextButton(
    child: Text('Modificar'),
    onPressed: () {
      final doc = FirebaseFirestore.instance.collection('examenes').doc(id);
      doc.update({
        'titulo': tecTitulo.text,
        'materia': tecMateria.text,
        'fecha': fechaUniversal,
        'nota': tecNota.text
      });
      Navigator.of(context).pop(); // cierra el dialog
    },
  );

  Widget checkButton = TextButton(
    child: Text('Terminado'),
    onPressed: () {
      final doc = FirebaseFirestore.instance.collection('examenes').doc(id);
      doc.update({
        'terminado': true
      });
      Navigator.of(context).pop(); // cierra el dialog
    },
  );


  // mostrando el dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {

      DateTime fecha = fechaLlega;

      final horas = fecha.hour.toString();
      final minutos = fecha.minute.toString();

      Future<DateTime?> seleccionarFecha() => showDatePicker(
        context: context,
        initialDate: fecha,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      Future<TimeOfDay?> seleccionarHora() => showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: fecha.hour, minute: fecha.minute)
      );

      return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: Text('Modificar examen'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Título:'),
                  TextField(
                    controller: tecTitulo,
                    decoration: new InputDecoration(contentPadding:EdgeInsets.all(6), border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade300), borderRadius: BorderRadius.circular(50.0)),hintText: 'Ingresa el título'),
                  ),
                  Text('Materia:'),
                  TextField(
                    controller: tecMateria,
                    decoration: new InputDecoration(contentPadding:EdgeInsets.all(6), border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade300), borderRadius: BorderRadius.circular(50.0)), hintText: 'Ingresa la materia'),
                  ),
                  Text('Fecha:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${fecha.year}/${fecha.month}/${fecha.day}'),
                      Text('${fecha.hour}:${fecha.minute}'),
                      TextButton(
                          onPressed: () async {
                            final fechaSeleccionada = await seleccionarFecha();
                            final horaSeleccionada = await seleccionarHora();

                            if(fechaSeleccionada == null) return; //si presiona cancelar
                            final nuevaFecha = DateTime(fechaSeleccionada.year, fechaSeleccionada.month, fechaSeleccionada.day, fecha.hour, fecha.minute);
                            setState(() {
                              fecha = nuevaFecha;
                              fechaUniversal = Timestamp.fromDate(fecha);
                            });

                            if(horaSeleccionada == null) return;
                            final nuevaHora = DateTime(fecha.year, fecha.month, fecha.day, horaSeleccionada.hour, horaSeleccionada.minute);
                            setState((){
                              fecha = nuevaHora;
                              fechaUniversal = Timestamp.fromDate(fecha);
                            });
                          },
                          child: Text('Seleccionar'))
                    ],
                  ),
                  Text('Nota:'),
                  TextField(
                    controller: tecNota,
                    decoration: new InputDecoration(contentPadding:EdgeInsets.all(6), border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade300), borderRadius: BorderRadius.circular(50.0)), hintText: 'Ingresa una nota'),
                  ),
                ],
              ),
              actions: [
                cancelButton,
                confirmButton,
                checkButton
              ],
            );
          }
      );
    },
  );
}

