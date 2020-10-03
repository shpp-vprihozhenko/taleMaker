import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChooseTaleToRestore extends StatefulWidget {
  @override
  _ChooseTaleToRestoreState createState() => _ChooseTaleToRestoreState();
}

class _ChooseTaleToRestoreState extends State<ChooseTaleToRestore> {
  List<String> taleNamesList = [];

  @override
  void initState() {
    readTaleNamesList();
    super.initState();
  }

  void readTaleNamesList() async {
    Box<dynamic> taleBox = await Hive.openBox('tales');
    Map<dynamic, dynamic> mappa = taleBox.toMap();

    print('read tales from box');
    print(mappa);

    mappa.forEach((key, value) {
      List<dynamic> dcCodes = jsonDecode(key);
      List<int> cCodes = [];
      dcCodes.forEach((element) {
        cCodes.add(element);
      });
      taleNamesList.add(new String.fromCharCodes(cCodes));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Выбери сказку'),
        ),
        body:
        ListView(
          children: _buildLW(),
        )
    );
  }

  List<Widget> _buildLW() {
    List<Widget> lt = [];
    for (int i=0; i<taleNamesList.length; i++) {
      lt.add(
          RaisedButton(
            color: i%2==0? Colors.white : Colors.grey[300],
              onPressed: (){
                Navigator.pop(context, taleNamesList[i]);
              },
              child:
              Text(taleNamesList[i], textScaleFactor: 1.2, style: TextStyle(color: Colors.black),)
          )
      );
    }
    return lt;
  }

}
