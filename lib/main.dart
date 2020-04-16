import 'dart:convert';
import 'package:flutter/material.dart';
import './addScreen.dart';
import './io.dart' as io;

void main() async {
  runApp(MaterialApp(
    title: "To-do List",
    theme: ThemeData(
      fontFamily: "Montserrat",
      hintColor: Colors.amber,
      primaryColor: Colors.black,
    ),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;
  bool dense = false;
  final title = 'Lista Bonitinha';

  @override
  void initState() {
    super.initState();

    io.getData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addItem(final result) {
    if(result == null || result == '')
      return;
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = result;
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
    });
    io.saveData(_toDoList);
  }

  List<Widget> list () {
    return <Widget>[
      Expanded(
        child: Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: _toDoList.length,
            itemBuilder: buildItem,
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          )
        ),
      ),
    ];
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
              onPressed: () {
                setState(() {
                  dense = !dense;
                });
              }
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.lightBlue, Colors.black
                          ]
                        ),
                        image: DecorationImage(
                          image: AssetImage("img/header_bg.png"),
                          fit: BoxFit.scaleDown,
                        )
                    ),
                    child: Text("Lukita"),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView(
                  children: <Widget>[
                    Container(
                      color: Colors.blue, 
                    ),
                  ], 
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Adicionar tarefa',
          child: const Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddScreen()),
            );

            _addItem(result);

            print(result);
          },
        ),
        body: dense ? Column(children: list()) : Row(children: list())
      ),
    );
  }

  Widget buildItem (context, index) {
    return Container(
      color: Colors.grey,
      child: Dismissible(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.8, 0.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            _lastRemoved = Map.from(_toDoList[index]);
            _lastRemovedIndex = index;
            _toDoList.removeAt(index);
          
            io.saveData(_toDoList);
          
            final snack = SnackBar(
              content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
              action: SnackBarAction(label: "Desfazer",
                  onPressed: () {
                    setState(() {
                      _toDoList.insert(_lastRemovedIndex, _lastRemoved);
                      io.saveData(_toDoList);
                    });
                  }),
              duration: Duration(seconds: 2),
            );
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(snack);
          });
        },
        child: CheckboxListTile(
          title: Text(_toDoList[index]["title"] ?? '', style: TextStyle(color: Colors.red)),
          value: _toDoList[index]["ok"],
          secondary: CircleAvatar(
            child: Icon(
              _toDoList[index]["ok"] ? Icons.check : Icons.error
            ),
          ),
          onChanged: (isOk){
            setState(() {
              _toDoList[index]["ok"] = isOk;
            });
            io.saveData(_toDoList);
          },
          dense: dense,
        ),
      )
    );
  }
}