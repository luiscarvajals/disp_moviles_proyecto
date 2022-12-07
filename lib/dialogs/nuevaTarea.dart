import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/tarea.dart';

dialogNuevaTarea(BuildContext context){

  Timestamp fechaUniversal = Timestamp.now();

  final tecTitulo = TextEditingController();
  final tecMateria = TextEditingController();
  final tecNota = TextEditingController();

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text('Cancelar'),
    onPressed: () {
      Navigator.of(context).pop(); // cierra el dialog
    },
  );

  Widget confirmButton = TextButton(
    child: Text('Confirmar'),
    onPressed: () {
      Tarea tarea = new Tarea('', tecTitulo.text, tecMateria.text, fechaUniversal, tecNota.text, false);
      tarea.crearTarea();
      Navigator.of(context).pop(); // cierra el dialog
    },
  );


  // mostrando el dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {

      DateTime fecha = DateTime.now();

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
              title: Text('Nueva tarea'),
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
              ],
            );
          }
      );
    },
  );
}

