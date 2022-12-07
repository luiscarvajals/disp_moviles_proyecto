import 'package:flutter/material.dart';
import 'package:proyecto_final/examenes.dart';
import 'package:proyecto_final/resumen.dart';
import 'package:proyecto_final/tareas.dart';
import 'dialogs/nuevaGrabacion.dart';
import 'dialogs/nuevaTarea.dart';
import 'dialogs/nuevoEvento.dart';
import 'dialogs/nuevoExamen.dart';
import 'drawer_header.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

import 'eventos.dart';
import 'grabaciones.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState(){
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  var paginaActual = DrawerItems.Resumen;

  @override
  Widget build(BuildContext context) {
    var contenedor;
    if(paginaActual == DrawerItems.Resumen){
      contenedor = PaginaResumen();
    } else if(paginaActual == DrawerItems.Tareas){
      contenedor = PaginaTareas();
    } else if(paginaActual == DrawerItems.Examenes){
      contenedor = PaginaExamenes();
    } else if(paginaActual == DrawerItems.Eventos){
      contenedor = PaginaEventos();
    } else if(paginaActual == DrawerItems.Grabaciones){
      contenedor = PaginaGrabaciones();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Color(0xff0E5EA8),
        ),
      body: contenedor,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Tarea",
            iconColor: Colors.white,
            bubbleColor: Color(0xff0E5EA8),
            icon: Icons.book,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: (){
              _animationController!.reverse();
              dialogNuevaTarea(context);
            }

          ),
          Bubble(
              title: "Exámen",
              iconColor: Colors.white,
              bubbleColor: Color(0xff0E5EA8),
              icon: Icons.star,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: (){
                _animationController!.reverse();
                dialogNuevoExamen(context);
              }
          ),
          Bubble(
              title: "Evento",
              iconColor: Colors.white,
              bubbleColor: Color(0xff0E5EA8),
              icon: Icons.calendar_month,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: (){
                _animationController!.reverse();
                dialogNuevoEvento(context);
              }
          ),
          Bubble(
              title: "Grabación",
              iconColor: Colors.white,
              bubbleColor: Color(0xff0E5EA8),
              icon: Icons.mic,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: (){
                _animationController!.reverse();
                dialogNuevaGrabacion(context);
              }
          ),
        ],
        animation: _animation!,
        onPress: () => _animationController!.isCompleted
          ? _animationController!.reverse()
          : _animationController!.forward(),
        backGroundColor: Color(0xff0E5EA8),
        iconColor: Colors.white,
        iconData: Icons.add,
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                HeaderDrawer(),
                DrawerLista()
              ]
            ),
          ),
        )

        /*ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Agenda Escolar',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xff0E5EA8)
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Resumen"),
              selected: true,
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Tareas"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Exámenes"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Eventos"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.mic),
              title: Text("Grabaciones"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),*/
      ),
    );
  }

  Widget DrawerLista(){
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, "Resumen", Icons.home, paginaActual == DrawerItems.Resumen ? true : false),
          menuItem(2, "Tareas", Icons.book, paginaActual == DrawerItems.Tareas ? true : false),
          menuItem(3, "Exámenes", Icons.star, paginaActual == DrawerItems.Examenes ? true : false),
          menuItem(4, "Eventos", Icons.calendar_month, paginaActual == DrawerItems.Eventos ? true : false),
          menuItem(5, "Grabaciones", Icons.mic, paginaActual == DrawerItems.Grabaciones ? true : false)
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected){
    return
        Material(
          color: selected ? Colors.grey[300] : Colors.transparent,
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
              setState(() {
                if(id == 1){
                  paginaActual = DrawerItems.Resumen;
                } else if(id == 2){
                  paginaActual = DrawerItems.Tareas;
                } else if(id == 3){
                  paginaActual = DrawerItems.Examenes;
                } else if(id == 4){
                  paginaActual = DrawerItems.Eventos;
                } else if(id == 5){
                  paginaActual = DrawerItems.Grabaciones;
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(child: Icon(icon, size: 20, color: Colors.black,)),
                  Expanded(flex: 1, child: Text(title, style: TextStyle(color: Colors.black, fontSize: 16),))
                ],
              ),
            ),
          ),
        );
  }
}

enum DrawerItems{
  Resumen,
  Tareas,
  Examenes,
  Eventos,
  Grabaciones,
}
