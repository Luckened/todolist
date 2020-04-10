import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar tarefa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildTextField('Tarefa', titleController),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context, titleController.text);
                },
                child: Text('Adicionar Tarefa!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTextField(String label, TextEditingController c) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(25.0)
      ),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
  );
}
