import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dialogs/modificarExamen.dart';
import 'models/examen.dart';

class PaginaExamenes extends StatefulWidget {
  const PaginaExamenes({Key? key}) : super(key: key);

  @override
  State<PaginaExamenes> createState() => _PaginaExamenesState();
}

class _PaginaExamenesState extends State<PaginaExamenes> {

  Future<List<Examen>>getTareas() async{
    CollectionReference core = FirebaseFirestore.instance.collection('examenes');
    QuerySnapshot examenes = await core.get();
    List<Examen> listaExamenes = [];
    if(examenes.docs.length > 0){
      for(var doc in examenes.docs){
        listaExamenes.add(Examen(doc['id'], doc['titulo'], doc['materia'], doc['fecha'], doc['nota'], doc['terminado']));
      }
    } else{
      print('La coleccion no existe');
    }
    return listaExamenes;
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
        stream: FirebaseFirestore.instance.collection('examenes').snapshots(),
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
                                  dialogModificarExamen(context, snapshot.data!.docs[index].reference.id, snapshot.data!.docs[index].get('titulo'), snapshot.data!.docs[index].get('materia'), (snapshot.data!.docs[index].get('fecha')).toDate(), snapshot.data!.docs[index].get('nota'));
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
