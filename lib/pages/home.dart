import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expert_socket/model/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metalica', votes: 5),
    // Band(id: '2', name: 'Papirri', votes: 4),
    // Band(id: '3', name: 'Marc Anthony', votes: 1),
    // Band(id: '4', name: 'Arjona', votes: 3),
    // Band(id: '5', name: 'Bon Jovi', votes: 2),
  ];

  @override
  void initState() {
    // TODO: implement initState
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handActiveBands);
    super.initState();
  }

  _handActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            actions: <Widget>[
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: (socketService.serverStatus == ServerStatus.online)
                      ? Icon(Icons.check_circle, color: Colors.green[300])
                      : const Icon(Icons.offline_bolt, color: Colors.red))
            ],
            title:
                const Text('BandNames', style: TextStyle(color: Colors.white))),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            _showGraph(),
            Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index) =>
                      bandTile(bands[index])),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: addNewBand,
          child: const Icon(Icons.add),
        ));
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};

    for (Band band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }
    final List<Color> colorList = [
      Colors.blue.shade300,
      Colors.red.shade300,
      Colors.yellow.shade300,
      Colors.green.shade300,
      Colors.brown.shade300,
      Colors.orange.shade300,
      
    ];
    return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          centerText: "BANDS",
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ));
  }

  Widget bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: const EdgeInsets.only(left: 12),
        color: Colors.red,
        child: const Align(
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
          onTap: () => socketService.socket.emit('vote-band', {'id': band.id})),
    );
  }

  addNewBand() {
    final nameController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
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
              ));
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
                child: const Text('Add'),
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      // bands.add(Band(id: DateTime.now.toString(), name: name, votes: 1));
      // setState(() {});
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }
}
