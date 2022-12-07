import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/tarea.dart';

class PaginaResumen extends StatefulWidget {
  const PaginaResumen({Key? key}) : super(key: key);

  @override
  State<PaginaResumen> createState() => _PaginaResumenState();
}

class _PaginaResumenState extends State<PaginaResumen> {

  Future<List<Tarea>>getTareas() async{
    CollectionReference core = FirebaseFirestore.instance.collection('tareas');
    QuerySnapshot tareas = await core.get();
    List<Tarea> listaTareas = [];
    if(tareas.docs.length > 0){
      for(var doc in tareas.docs){
        listaTareas.add(Tarea(doc['id'], doc['titulo'], doc['materia'], doc['fecha'], doc['nota'], doc['terminado']));
      }
    } else{
      print('La coleccion no existe');
    }
    return listaTareas;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd-MM-yyyy hh:mm');

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // inside the <> you enter the type of your stream
        stream: FirebaseFirestore.instance.collection('tareas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if(snapshot.data!.docs[index].get('terminado') == false){
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
                              Text(
                                snapshot.data!.docs[index].get('nota'),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                  dialogModificarTarea(context, snapshot.data!.docs[index].reference.id, snapshot.data!.docs[index].get('titulo'), snapshot.data!.docs[index].get('materia'), (snapshot.data!.docs[index].get('fecha')).toDate(), snapshot.data!.docs[index].get('nota'));
                                },
                                child: Icon(Icons.edit, color: Colors.white,),
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
                } else{
                  return Container(

                  );
                }
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
