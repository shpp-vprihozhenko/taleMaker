import 'package:web_socket_channel/html.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ChooseTaleToRestore.dart';
import 'taleLib.dart';
import 'package:taleRepair/About.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'EditWordOptions.dart';
import 'EnterTaleName.dart';
import 'ChooseNewOrExist.dart';
import 'ExchTales.dart';

enum TtsState { playing, stopped, paused, continued }
Color taleBG = Colors.tealAccent[100];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(MyApp());
}

List <String> splitWordAndPunctuation(String sourceWord){
  String word = sourceWord;
  String lastChar = word.length < 2? '' : word[word.length-1];
  if (lastChar != '') {
    if ('.,!:#%^&*();-+?<>/\'\"\$'.indexOf(lastChar) > -1) {
      word = word.substring(0, word.length-1);
    } else {
      lastChar = '';
    }
  }
  return [word, lastChar];
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

initHive() async {
  print('init hive');
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    final appDocDir = await path_provider.getApplicationDocumentsDirectory();
    print('got path ${appDocDir.path}');
    await Hive.initFlutter(appDocDir.path);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Придумай сказку!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Придумай сказку!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> myTale;
  String myTaleName = '', myNickName = '';
  var myOptions;
  List<String> selectedOptions;

  int curL, curW;
  bool stopTale = false, playMode = false;
  String myTaleBGpic;
  var hiveVarBox;
  bool startMode = true, zeroStartMode = true;

  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 1;
  double pitch = 1.4;
  double rate = 1;

  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  final _scrollController1 = ScrollController();
  double opacityLvl = 1.0;
  var hiveSaveBox;

  @override
  void initState() {
    //Box<dynamic> nickNameBox = Hive.openBox('nickName').then((value) {
    Hive.openBox('nickName').then((nickNameBox) {
      myNickName = nickNameBox.get('nick');
      print('got saved nickname $myNickName');
    });

    myTale = getKRtale();
    myOptions = getOptions2();

    prepareWordOptionsAndRandomizeAnimation();

    myTaleBGpic = getBGpicName();
    selectedOptions = [];
    selectedOptions.add('Смотри какую сказку придумал твой умный телефон)\n'
        'А ты сможешь придумать лучше?\n'
        'Нажми на слово, которое ты хочешь изменить. \n'
        'Потом в нижем окне выбери (или добавь свою) замену. \n'
        'И послушай, что получилось!\n'
        'Перешли другу и посмейтесь вместе)');
/*
    selectedOptions.add('Телефонный вирус погрыз Курочку Рябу!\nИ сказка стала не совсем правильной...\n'
        'Отремонтируй её! Нажми на слово, которое ты хочешь заменить. \n'
        'Потом выбери в нижем окне замену. \n'
        'И послушай, что получилось!\n'
        'Можно также придумать новую сказку)');
*/
    initTts();
    super.initState();
  }

  prepareWordOptionsAndRandomizeAnimation() async {
    hiveVarBox = await Hive.openBox('krOptions');
    if (hiveVarBox.length == 0) {
      hiveVarBox.put('krOpt', jsonEncode(myOptions));
    } else {
      myOptions = jsonDecode(hiveVarBox.get('krOpt'));
    }

    await delay(2000);

    setState(() {
      opacityLvl = 0;
    });

    await delay(2000);

    randomizeMyTale();

    setState(() {
      zeroStartMode = false;
      opacityLvl = 1;
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (!isSupportedLanguageInList()) {
      showAlertPage(
          'Извините, в Вашем телефоне не установлен требуемый TTS-язык. Обновите ваш синтезатор речи (Google TTS).');
    }
  }

  isSupportedLanguageInList() {
    for (var lang in languages) {
      if (lang.toString().toUpperCase() == 'RU-RU') {
        print('ru lang present');
        return true;
      }
    }
    print('no ru lang present');
    return false;
  }

  Future _setSpeakParameters() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(1);
    await flutterTts.setPitch(pitch);
    // ru-RU uk-UA en-US
    await flutterTts.setLanguage('ru-RU');
  }

  Future<void> _speak(String _text, bool asyncMode) async {
    if (_text != null) {
      if (_text.isNotEmpty) {
        if (asyncMode) {
          flutterTts.speak(_text);
        } else {
          await flutterTts.speak(_text);
        }
      }
    }
  }

  Future<void> _speakSync(String _text) {
    final c = new Completer();
    flutterTts.setCompletionHandler(() {
      c.complete("ok");
    });
    _speak(_text, false);
    return c.future;
  }

  Future<void> delay(int dur) {
    final c = new Completer();
    Future.delayed(Duration(milliseconds: dur), () {
      c.complete("ok");
    });
    return c.future;
  }

  initTts() {
    flutterTts = FlutterTts();
    _getLanguages();
    _setSpeakParameters();
  }

  void randomizeMyTale() {
    for (int i=0; i<myTale.length; i++) {
      List <String> lineWords = myTale[i].split(' ');
      for (int j=0; j < lineWords.length; j++) {
        List <String> lwp = splitWordAndPunctuation(lineWords[j]);
        String sourceWord = lwp[0];
        String lastChar = lwp[1];
        List <String> lOptions = findOpt2(myOptions, sourceWord);
        if (lOptions.length == 0) {
          continue;
        }
        lineWords[j] = chooseNewRandomWord(lOptions) + lastChar;
      }
      myTale[i] = lineWords.join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('images/'+myTaleBGpic),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: AnimatedOpacity(
                opacity: opacityLvl,
                duration: Duration(seconds: 2),
                child: Container(
                  child: Scrollbar(
                    controller: _scrollController1, // <---- Here, the controller
                    isAlwaysShown: true,
                    child: ListView(
                      controller: _scrollController1,
                      children: taleWList(),
                    ),
                  ),
                ),
              )
            ),
            zeroStartMode? SizedBox() :
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlueAccent.withOpacity(0.5),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          child: playMode?
                          SizedBox(height:10)
                          : Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: addonsWList(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      width: 35, height: 35,
                      child: startMode? SizedBox(height: 10) :
                        FloatingActionButton(onPressed: _editWordOptions, tooltip: 'Добавить слово', child: Icon(Icons.edit, size: 25,), heroTag: "btnEdit",)
                    )
                  ],
                ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.brown[300],
          height: 60,
          child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(onPressed: _showAbout, tooltip: 'О программе', child: Text('?', textScaleFactor: 2,), heroTag: "btnAbout",),
            FloatingActionButton(onPressed: _shuffleWords, tooltip: 'Новая сказка', child: Icon(Icons.shuffle, size: 30,), heroTag: "btnShuffle"),
            playMode? FloatingActionButton(onPressed: _stopTaleReading, tooltip: 'Остановить чтение', child: Icon(Icons.stop, size: 30,), heroTag: "btnStop") : FloatingActionButton(onPressed: _soundCurTale, tooltip: 'Прочитать сказку', child: Icon(Icons.play_arrow, size: 30,), heroTag: "btnSpeak"),
            FloatingActionButton(onPressed: _saveCurTale, tooltip: 'Сохранить сказку', child: Icon(Icons.save_alt, size: 30,), heroTag: "btnSaveTale"),
            FloatingActionButton(onPressed: _restoreCurTale, tooltip: 'Открыть сказку', child: Icon(Icons.restore_page, size: 30,), heroTag: "btnRestoreTale"),
            FloatingActionButton(onPressed: _exchTales, tooltip: 'Обмен сказками', child: Icon(Icons.language, size: 30,), heroTag: "btnExch"),
          ],
      )),
    );
  }

  void _soundCurTale() async {
    setState(() {
      playMode = true;
    });
    for (int i=0; i < myTale.length; i++) {
      await _speakSync(myTale[i]);
      await delay(100);
      if (stopTale) {
        stopTale = false;
        break;
      }
    }
    setState(() {
      playMode = false;
    });
  }

  List<Widget> addonsWList() {
    List <Widget> addonsWL = [];
    selectedOptions.forEach((element) {
      addonsWL.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.yellow,
              highlightColor: Colors.blue.withOpacity(0.5),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Text(element, textScaleFactor: 1.3, textAlign: TextAlign.center,),
                  )
              ),
                onTap: () {
                  setState(() {
                    replaceCurWordOfTale(element);
                  });
                },
            ),
          )
      );
    });
    addonsWL.shuffle();
    return addonsWL;
  }

  List<Widget> taleWList() {
    List<Widget> twl = [];
    for (int i=0; i < myTale.length; i++) {
      List<String> wordsL = myTale[i].split(' ');
      List<Widget> wordsWL = [];
      for (int j=0; j < wordsL.length; j++) {
        wordsWL.add(
            InkWell(
              splashColor: Colors.yellow,
              highlightColor: Colors.blue.withOpacity(0.5),
              onTap: () {
                curL = i; curW = j; startMode = false;
                setState(() {
                  findOptions(i, j);
                });
              },
              child: Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ((i==curL && j==curW)? Colors.teal[200]: taleBG),
                  ),
                  //color: ((i==curL && j==curW)? Colors.teal[200]: taleBG),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(wordsL[j]+' ', textScaleFactor: 1.25,),
                  )
              ),
            )
        );
      }
      twl.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: wordsWL,
          ),
        )
      );
    }
    return twl;
  }

  List<String> getConcreteOptions(int i, int j) {
    List <String> lWordsOfCurRow = myTale[i].split(' ');
    String word = splitWordAndPunctuation(lWordsOfCurRow[j])[0];
    return findOpt2(myOptions, word);
  }

  String chooseNewRandomWord(List<String> lVariants) {
    var rng = new Random();
    return lVariants[rng.nextInt(lVariants.length)];
  }

  void findOptions(int i, int j) {
    selectedOptions = getConcreteOptions(i, j);
  }

  void replaceCurWordOfTale(String newWord) {
    String curS = myTale[curL];
    List <String> words = curS.split(' ');
    words[curW] = newWord + splitWordAndPunctuation(words[curW])[1];
    myTale[curL] = words.join(' ');
  }

  showAlertPage(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(msg),
          );
        }
    );
  }

  _shuffleWords(){
    randomizeMyTale();
    setState(() {
      curL=-1; curW=-1;
    });
  }

  _stopTaleReading(){
    stopTale = true;
  }

  _showAbout(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => new About()),);
  }

  void _saveCurTale() async {
    if (myTaleName == '') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EnterTaleName()),)
      .then((taleName) {
        if (taleName == null) {
          return;
        }
        if (taleName!='') {
          myTaleName = taleName;
          print('new myTaleName $myTaleName');
        }
        saveMyTaleToHiveBox(taleName);
      });
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseNewOrExist(myTaleName)),)
      .then((choice) {
        if (choice != null) {
          if (choice == 'exist') {
            saveMyTaleToHiveBox(myTaleName);
          } else if (choice == 'new') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EnterTaleName()),)
                .then((taleName) {
              if (taleName!='') {
                myTaleName = taleName;
                print('new myTaleName $myTaleName');
              }
              saveMyTaleToHiveBox(taleName);
            });
          }
        }
      });
      
    }
  }

  saveMyTaleToHiveBox(String taleName) async {
    if (taleName.toString().trimLeft() == '') {
      showAlertPage('Не сохранил.');
      return;
    }
    var taleBox = await Hive.openBox('tales');
    List <String> newTale = []; newTale.addAll(myTale);

    List<int> cCodes = taleName.codeUnits;
    String encodedName = jsonEncode(cCodes);
    print('encodedName $encodedName');

    taleBox.put(encodedName, newTale);
    showAlertPage('Сохранил $taleName!');
  }

  void _restoreCurTale() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseTaleToRestore()),)
        .then((taleName) async {
      print('got taleName to read $taleName');
      if (taleName == null) {
        return;
      }
      if (taleName!='') {
        myTaleName = taleName;
        Box<dynamic> taleBox = await Hive.openBox('tales');
        List<int> cCodes = taleName.codeUnits;
        String encodedName = jsonEncode(cCodes);
        print('encodedName $encodedName');
        var taleL = taleBox.get(encodedName);
        myTale = [];
        setState(() {
          for (int i=0; i < taleL.length; i++) {
            myTale.add(taleL[i]);
          }
        });
      }
    });
  }

  _editWordOptions() async {
    List <String> lineWords = myTale[curL].split(' ');
    String sourceWord = splitWordAndPunctuation(lineWords[curW])[0];
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditWordOptions(sourceWord, myOptions)),)
    .then((value) {
      print('myOptions');
      print(myOptions);
      hiveVarBox.put('krOpt', jsonEncode(myOptions));
      selectedOptions = getConcreteOptions(curL, curW);
      setState((){});
    });
  }

  _exchTales() {
    var params = [];
    params.add(myTaleName);
    params.add(myNickName);
    params.add(myTale);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ExchTales(params)),)
    .then((value) {
      print('come back from exchTales');
      print('params $params');
      print('value');
      print(value);
      myTaleName = params[0];
      myNickName = params[1];
      if (value != null) {
        print('got another tale from server');
        var tale = jsonDecode(value);
        var taleText = jsonDecode(tale['text']);
        myTale = [];
        taleText.forEach((el){
          myTale.add(el as String);
        });
        setState((){});
      }
    });
  }
}



