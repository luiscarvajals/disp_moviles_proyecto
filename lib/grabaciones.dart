import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_final/models/grabacion.dart';

class PaginaGrabaciones extends StatefulWidget {
  const PaginaGrabaciones({Key? key}) : super(key: key);

  @override
  State<PaginaGrabaciones> createState() => _PaginaGrabacionesState();
}

class _PaginaGrabacionesState extends State<PaginaGrabaciones> {

  Future<List<Grabacion>>getGrabaciones() async{
    CollectionReference core = FirebaseFirestore.instance.collection('grabaciones');
    QuerySnapshot grabaciones = await core.get();
    List<Grabacion> listaGrabaciones = [];
    if(grabaciones.docs.length > 0){
      for(var doc in grabaciones.docs){
        listaGrabaciones.add(Grabacion(doc['id'], doc['titulo'], doc['materia'], doc['fecha'], doc['ruta']));
      }
    } else{
      print('La coleccion no existe');
    }
    return listaGrabaciones;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd-MM-yyyy hh:mm');

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('grabaciones').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.docs[index].get('titulo'),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                snapshot.data!.docs[index].get('materia'),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                f.format((snapshot.data!.docs[index].get('fecha')).toDate()).toString(),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                },
                                child: Icon(Icons.play_arrow, color: Colors.white,),
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(6.0)
                                ),
                              ),
                              ElevatedButton(
                              onPressed: (){
                                Widget okButton = TextButton(
                                  child: Text("Confirmar"),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance.runTransaction((transaction) async => await transaction.delete(snapshot.data!.docs[index].reference));
                                    Navigator.of(context).pop();
                                  },
                                );

                                Widget cancelButton = TextButton(
                                  child: Text("Cancelar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );

                                AlertDialog alert = AlertDialog(
                                  title: Text("Borrar grabación?"),
                                  content: Text("¿Está seguro de eliminar la grabación?"),
                                  actions: [
                                    okButton,
                                    cancelButton
                                  ],
                                );

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                              child: Icon(Icons.delete, color: Colors.white,),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(6.0)
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
              },
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}