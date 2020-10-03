import 'package:flutter/material.dart';

class EditWordOptions extends StatefulWidget {
  final sourceWord;
  final taleOptions;

  EditWordOptions(this.sourceWord, this.taleOptions);

  @override
  _EditWordOptionsState createState() => _EditWordOptionsState(this.sourceWord, this.taleOptions);
}

class _EditWordOptionsState extends State<EditWordOptions> {
  final String sourceWord;
  final taleOptions;

  _EditWordOptionsState(this.sourceWord, this.taleOptions);

  List <dynamic> wordOptionsList = [];
  int optionsLineNumber = -1;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fillExistingWordOptionsListAndDefineItLineNumber();
  }

  fillExistingWordOptionsListAndDefineItLineNumber() {
    for (int i=0; i < taleOptions.length; i++ ) {
      List <dynamic> options = taleOptions[i];
      bool isSourceInOptions = false;
      options.forEach((element) {
        if (sourceWord.toUpperCase() == element.toUpperCase()) {
          isSourceInOptions = true;
        }
      });
      if (isSourceInOptions) {
        optionsLineNumber = i;
        wordOptionsList = options;
        break;
      }
    }
    if (optionsLineNumber == -1) {
      wordOptionsList.add(sourceWord);
    }
  }

  List <String> findOpt2(var opt2, String s) {
    List<String> res = [];
    opt2.forEach((lOpts) {
      bool isInList = false;
      lOpts.forEach((el){
        if (s.toUpperCase()==el.toUpperCase()){
          isInList = true;
        }
      });
      if (isInList) {
        lOpts.forEach((element){
          if (res.indexOf(element)==-1)
            res.add(element);
        });
      }
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавляем слова."),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                Expanded(child:
                  TextField(
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(labelText: 'Ваш вариант'),
                    controller: myController,
                  ),
                ),
                IconButton(icon: Icon(Icons.add), onPressed: _addNewWordToOptions)
              ]),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: wordOptionsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(title:
                      Row(
                        children: [
                          Expanded(child: Text(wordOptionsList[index], textScaleFactor: 1.2,)),
                          IconButton(icon: Icon(Icons.delete),
                            onPressed: () {
                              _delWordFromOptions(index);
                            }
                          )
                        ],
                      ),);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addNewWordToOptions() {
    wordOptionsList.insert(0, myController.text);
    setState(() {
      myController.text="";
    });
    updateTaleOptions();
  }

  _delWordFromOptions(index) {
    setState(() {
      wordOptionsList.removeAt(index);
    });
    updateTaleOptions();
  }

  updateTaleOptions(){
    if (optionsLineNumber > -1) {
      taleOptions[optionsLineNumber] = wordOptionsList;
    } else {
      taleOptions.add(wordOptionsList);
      optionsLineNumber = taleOptions.length - 1;
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  showMyDialog(String textMsg){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(textMsg),
        );
      }
    );
  }
}


