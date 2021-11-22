import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
//import 'package:web_socket_channel/html.dart';

import 'showAlertPage.dart';
import 'requestToWss.dart';


class ExchTales extends StatefulWidget {
  final params;
  ExchTales(this.params);

  @override
  _ExchTalesState createState() => _ExchTalesState(params);
}

class _ExchTalesState extends State<ExchTales> {
  final params;
  _ExchTalesState(this.params);

  String nickName='', taleName='', receiverNickName='';
  List<String> myTale = [];
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  //bool wssChannelIsListened = false;
  bool sendMode=false, receiveMode=false;

  @override
  void initState() {
    taleName = params[0];
    nickName = params[1];
    myTale = params[2];

    print('got params taleName $taleName nickName $nickName and tale');
    //print(myTale);

    _controller.text = nickName;
    _controller2.text = taleName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Обмен сказками."),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Твой псевдоним:',),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent[100],
                    child: IconButton(
                      icon: Icon(Icons.done),
                      onPressed: (){
                        processNewNickName(true);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller2,
                      decoration: InputDecoration(labelText: 'Название твоей сказки:',),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent[100],
                    child: IconButton(
                      icon: Icon(Icons.done),
                      onPressed: (){
                        processNewTaleName(true);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              sendMode? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller3,
                      decoration: InputDecoration(labelText: 'Псевдоним получателя:',),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent[100],
                    child: IconButton(
                      icon: Icon(Icons.done),
                      onPressed: (){},
                    ),
                  )
                ],
              ) : SizedBox(),
              SizedBox(height: 20),
              sendMode? FlatButton(
                  height: 50,
                  color: Colors.lightGreenAccent[100],
                  hoverColor: Colors.lightGreenAccent,
                  onPressed: () {
                    if (_controller.text == '' || _controller2.text == '') {
                      showAlertPage(context, 'Укажи пожалуйста псевдоним и название сказки.');
                      return;
                    }
                    if (_controller3.text == '') {
                      showAlertPage(context, 'Укажи пожалуйста псевдоним получателя.');
                      return;
                    }
                    if (taleName != _controller2.text) {
                      processNewTaleName(false);
                    }
                    if (nickName != _controller.text) {
                      processNewNickName(false);
                    }
                    receiverNickName = _controller3.text;
                    sendMyTaleToReceiver();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Отправить!'),
                      SizedBox(width: 10),
                      Icon(Icons.send),
                    ],
                  )
              ) : SizedBox(),
              sendMode? SizedBox() : FlatButton(
                  height: 50,
                  color: Colors.lightBlueAccent[100],
                  hoverColor: Colors.lightBlueAccent,
                  onPressed: () {
                    if (_controller.text == '' || _controller2.text == '') {
                      showAlertPage(context, 'Укажи пожалуйста псевдоним и название сказки.');
                      return;
                    }
                    if (taleName != _controller2.text) {
                      processNewTaleName(false);
                    }
                    if (nickName != _controller.text) {
                      processNewNickName(false);
                    }
                    setState(() {
                      sendMode = true;
                    });
                    //sendTaleTo();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Отправить сказку другу'),
                      SizedBox(width: 10),
                      Icon(Icons.send),
                    ],
                  )
              ),
              SizedBox(height: 20),
              sendMode? SizedBox() : FlatButton(
                height: 50,
                  color: Colors.lightBlueAccent[100],
                  hoverColor: Colors.lightBlueAccent,
                  onPressed: (){
                    if (_controller.text == '' || _controller2.text == '') {
                      showAlertPage(context, 'Укажи пожалуйста свои псевдоним и название сказки.');
                      return;
                    }
                    if (taleName != _controller2.text) {
                      processNewTaleName(false);
                    }
                    if (nickName != _controller.text) {
                      processNewNickName(false);
                    }
                    receiveTale(nickName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Получить сказку'),
                      SizedBox(width: 10),
                      Icon(Icons.email),
                    ],
                  )
              ),
              SizedBox(height: 20),
              sendMode? SizedBox() : FlatButton(
                  height: 50,
                  color: Colors.lightBlueAccent[100],
                  hoverColor: Colors.lightBlueAccent,
                  onPressed: (){
                    receiveTale('all');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Все сказки в сети'),
                      SizedBox(width: 10),
                      Icon(Icons.local_library),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }

  void addNick(String nick, cb) async {
    print('addNick');
    var res = await reqWss('check/$nick');
    String ress = res as String;
    if (ress.substring(0,2)!='ok') {
      cb(ress, '');
      return;
    }
    if (nickName == null || nickName.isEmpty){
      print('try to add');
      res = await reqWss('add/$nick');
    } else {
      print('try to update');
      res = await reqWss('update/$nick/$nickName');
    }
    ress = res as String;
    print('got ress on add/update $ress');
    if (ress.substring(0,2)!='ok') {
      cb(ress, '');
    } else {
      cb('',ress);
    }
  }

  processNewTaleName(bool needToShowOkMsg) {
    String newTaleName = _controller2.text;
    print('got tale name $newTaleName');
    if (newTaleName == '' ||  newTaleName == taleName) {
      print('no need to update taleName');
      return;
    }
    taleName = newTaleName;
    params[0] = newTaleName;

    List <String> newTale = []; newTale.addAll(myTale);

    List<int> cCodes = taleName.codeUnits;
    String encodedName = jsonEncode(cCodes);
    print('save tale with encodedName $encodedName');

    //var taleBox = Hive.openBox('tales');
    Hive.openBox('tales').then((taleBox){
      taleBox.put(encodedName, newTale);
      if (needToShowOkMsg)
        showAlertPage(context, 'Сохранил сказку $taleName!');
    });
  }

  processNewNickName(bool needToShowOkMsg) {
    print('got ${_controller.text}');
    String newNick=_controller.text;
    if (newNick == '' ||  newNick == nickName) {
      print('no need to update nick');
      return;
    }
    addNick(_controller.text, (err, res){
      if (err.isNotEmpty) {
        showAlertPage(context, err);
      } else {
        nickName = newNick;
        params[1] = newNick;
        Hive.openBox('nickName').then((nickNameBox) {
          nickNameBox.put('nick', nickName);
          if (needToShowOkMsg)
            showAlertPage(context, 'Сохранил псевдоним $nickName!');
        });
        print('save nickName $nickName');
      }
    });
  }

  sendMyTaleToReceiver() async {
    if (nickName == null) {
      nickName = _controller.text;
    }
    if (nickName == null) {
      showAlertPage(context, 'Представьтесь, пожалуйста.');
    }
    print('sending to $receiverNickName from $nickName');
    String res = await reqWss('send/$receiverNickName/$nickName/$taleName/'+jsonEncode(myTale));
    if (res == 'ok') {
      showAlertPage(context, 'Отправил!');
      setState(() {
        sendMode = false;
      });
    } else {
      showAlertPage(context, res);
    }
  }

  receiveTale(String name) async {
    print('receiving tale for $name');
    String res = await reqWss('receive/$name');
    try {
      var tales = jsonDecode(res);
      Navigator.push(context, MaterialPageRoute(builder: (context) => WorkWithForeignTales(tales, name)))
      .then((resultChoice){
        print('selected tale $resultChoice');
        if (resultChoice != null) {
          Navigator.pop(context, resultChoice);
        }
      });
    } catch (e){
     print(e);
    }
  }

}


class WorkWithForeignTales extends StatefulWidget {
  final tales;
  final name;
  WorkWithForeignTales(this.tales, this.name);
  
  @override
  _WorkWithForeignTalesState createState() => _WorkWithForeignTalesState();
}

class _WorkWithForeignTalesState extends State<WorkWithForeignTales> {

  @override
  void initState() {
    print('tales list ${widget.tales}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сказки, которые ждут тебя:'),
      ),
      body: ListView.builder(
          itemCount: widget.tales.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              tileColor: index % 2 == 0? Colors.white : Colors.yellow[100] ,
              title: FlatButton(
                onPressed: (){
                  print('select $index tale');
                  Navigator.pop(context, jsonEncode(widget.tales[index]));
                },
                child: Text(widget.tales[index]['fromNick']+' - '+widget.tales[index]['tailName'], textScaleFactor: 1.2, textAlign: TextAlign.center,)
              ),
              trailing: widget.name == 'all'
              ? SizedBox()
              : Container(
                width: 25, height: 25,
                child: FloatingActionButton(
                  tooltip: 'Удалить.',
                  backgroundColor: Colors.redAccent,
                  heroTag: 'killTaleOnServer$index',
                  onPressed: (){
                    print('selected to del $index tale');
                    delTaleOnServer(index);
                  },
                  child: Icon(Icons.delete_forever, size: 20),
                ),
              ),
            );
          }),
    );
  }

  delTaleOnServer(index) {
    var jTaleToDel = jsonEncode(widget.tales[index]);
    print('del $jTaleToDel');
    reqWss('del/$jTaleToDel');
    setState(() {
      widget.tales.removeAt(index);
    });
  }
}
