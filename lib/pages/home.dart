import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expert_socket/model/band.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Papirri', votes: 4),
    Band(id: '3', name: 'Marc Anthony', votes: 1),
    Band(id: '4', name: 'Arjona', votes: 3),
    Band(id: '5', name: 'Bon Jovi', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            title:
                const Text('BandNames', style: TextStyle(color: Colors.white))),
        body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) =>
                bandTile(bands[index])),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: addNewBand,
          child: const Icon(Icons.add),
        ));
  }

  Widget bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direccion: $direction   id: ${band.id}');
      },
      background: Container(
        padding: EdgeInsets.only(left: 12),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Delete Band",
              style: TextStyle(color: Colors.white),
            )),
      ),
      key: Key(band.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final nameController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("new band name:"),
            content: TextField(controller: nameController),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => addBandToList(nameController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text("add"),
              )
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text("New Band name:"),
            content: CupertinoTextField(
              controller: nameController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList(nameController.text),
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text('Dismiss'),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now.toString(), name: name, votes: 1));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
