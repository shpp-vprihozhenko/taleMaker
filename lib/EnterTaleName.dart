import 'package:flutter/material.dart';

class EnterTaleName extends StatefulWidget {
  @override
  _EnterTaleNameState createState() => _EnterTaleNameState();
}

class _EnterTaleNameState extends State<EnterTaleName> {

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Сохранение сказки')
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text('Придумай название сказки!', textScaleFactor: 1.4,),
              SizedBox(height: 10,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(child:
                    TextField(
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(labelText: 'сказка называется...'),
                      controller: myController,
                    ),
                    ),
                    FlatButton(
                        color: Colors.blueAccent[100],
                        child: Text('Ok'),
                        onPressed: _setTaleName
                    )
                  ]),
            ],
          ),
        )
    );
  }

  _setTaleName(){
    print('got ${myController.text}');
    Navigator.pop(context, myController.text);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
}
