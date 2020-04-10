import 'package:flutter/material.dart';
import './addScreen.dart';

void main() async {
  runApp(MaterialApp(
    title: "To-do List",
    theme: ThemeData(
      fontFamily: "Montserrat",
      hintColor: Colors.amber,
      primaryColor: Colors.black,
      backgroundColor: Colors.blueGrey,
    ),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final title = 'Lista Bonitinha';
  
  _waitAdd(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddScreen()),
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Pesquisar tarefa',
              splashColor: Colors.black,
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.view_module),
              tooltip: 'Mudar visualização de tarefas',
              splashColor: Colors.black,
              onPressed: (){},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.blue, 
              ),
            ], 
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Adicionar tarefa',
          child: const Icon(Icons.add),
          onPressed: () {
            _waitAdd(context);
          },
        ),
      ),
    );
  }
}