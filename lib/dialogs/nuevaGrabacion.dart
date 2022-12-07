import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyecto_final/models/grabacion.dart';
import 'package:soundpool/soundpool.dart';

dialogNuevaGrabacion(BuildContext context){
  final recorder = FlutterSoundRecorder();
  bool recorderListo = false;
  Timestamp fechaUniversal = Timestamp.now();
  String timeStamp = new DateFormat("yyyyMMdd_HHmmss").format(DateTime.now());
  var archivo;
  var ruta;

  void dispose(){
    recorder.closeRecorder();
  }

  Future record() async {
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw 'No se dio permiso al microfono';
    } else{
      await recorder.openRecorder();
      recorderListo = true;
      recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
      await recorder.startRecorder(toFile: 'grabacion_${timeStamp}', codec: Codec.defaultCodec);
    }
  }

  Future stop() async {
    if(!recorderListo) return;

    ruta = await recorder.stopRecorder();
    archivo = File(ruta!);
    print(archivo);
  }

  final tecTitulo = TextEditingController();
  final tecMateria = TextEditingController();

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
      final rutaFirebase = 'files/${tecTitulo.text}';
      final ref = FirebaseStorage.instance.ref().child(rutaFirebase);
      ref.putFile(archivo);

      Grabacion grabacion = new Grabacion('', tecTitulo.text, tecMateria.text, Timestamp.now(), rutaFirebase);
      grabacion.crearGrabacion();

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
              title: Text('Nueva grabacion'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      StreamBuilder<RecordingDisposition>(
                        stream: recorder.onProgress,
                        builder: (context, snapshot){
                          final duracion = snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                          return Text('${duracion.inSeconds} s');
                        },
                      ),
                      const SizedBox(height: 30,),
                      ElevatedButton(
                        child: Icon(recorder.isRecording ? Icons.stop : Icons.mic,
                          size: 50,
                        ),
                        onPressed: () async {
                          if(recorder.isRecording){
                            await stop();
                          } else {
                            await record();
                          }
                          setState(() {});
                        },
                      ),
                    ]
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.blue[100],
                    child: ElevatedButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: () async {
                        Soundpool pool = Soundpool(streamType: StreamType.notification);

                        int soundId = await rootBundle.load(ruta).then((ByteData soundData) {
                          return pool.load(soundData);
                        });
                        int streamId = await pool.play(soundId);
                      },
                    ),
                  )
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