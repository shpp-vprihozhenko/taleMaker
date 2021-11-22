import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChooseTaleToRestore extends StatefulWidget {
  @override
  _ChooseTaleToRestoreState createState() => _ChooseTaleToRestoreState();
}

class _ChooseTaleToRestoreState extends State<ChooseTaleToRestore> {
  List <String> taleNamesList = [];
  List <String> keys = [];

  @override
  void initState() {
    readTaleNamesList();
    super.initState();
  }

  void readTaleNamesList() async {
    keys = []; taleNamesList = [];
    Box<dynamic> taleBox = await Hive.openBox('tales');
    Map<dynamic, dynamic> mappa = taleBox.toMap();

    print('read tales from box');
    print(mappa);

    mappa.forEach((key, value) {
      List<dynamic> dcCodes = [];
      try {
        dcCodes = jsonDecode(key);
        List<int> cCodes = [];
        dcCodes.forEach((element) {
          cCodes.add(element);
        });
        taleNamesList.add(new String.fromCharCodes(cCodes));
      } catch(e) {
        print('got err on decode $e');
        taleNamesList.add(key);
      }
      keys.add(key);
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
          Row(
            children: [
              Expanded(
                child: RaisedButton(
                  color: i%2==0? Colors.white : Colors.grey[300],
                    onPressed: (){
                      Navigator.pop(context, taleNamesList[i]);
                    },
                    child:
                    Text(taleNamesList[i], textScaleFactor: 1.2, style: TextStyle(color: Colors.black),)
                ),
              ),
              IconButton(icon: Icon(Icons.delete_forever), onPressed: (){delTale(keys[i]);}),
            ],
          )
      );
    }
    return lt;
  }

  delTale(String key) {
    print('delTale $key');
    //Box<dynamic> taleBox = await Hive.openBox('tales');
    Hive.openBox('tales').then((taleBox){
      taleBox.delete(key);
      readTaleNamesList();
      setState(() {});
    });
  }

}
