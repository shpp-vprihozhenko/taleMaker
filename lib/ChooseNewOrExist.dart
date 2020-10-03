import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseNewOrExist extends StatefulWidget {
  final taleName;

  ChooseNewOrExist(this.taleName);

  @override
  _ChooseNewOrExistState createState() => _ChooseNewOrExistState(taleName);
}

class _ChooseNewOrExistState extends State<ChooseNewOrExist> {
  final taleName;

  _ChooseNewOrExistState(this.taleName);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Ваша сказка уже имеет название!', textScaleFactor: 1.3,),
      content: Text(taleName, textScaleFactor: 1.4,),
      actions: [
        CupertinoDialogAction(child: Text('Сохранить с этим же названием', textScaleFactor: 1.6,), onPressed: (){
          Navigator.pop(context, 'exist');
        },),
        CupertinoDialogAction(child: Text('Придумать новое название', textScaleFactor: 1.6,), onPressed: (){
          Navigator.pop(context, 'new');
        },),
      ],
    );
  }


}
