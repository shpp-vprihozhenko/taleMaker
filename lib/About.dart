import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle stl = TextStyle(fontSize: 16, color: Colors.blue[900],);
    return Scaffold(
      appBar: AppBar(
        title: Text("О программе."),
      ),
      body:
      Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(height: 10,),
//              Text('Восстанови сказку!', style: stl, textScaleFactor: 1.5, textAlign: TextAlign.center,),
              Text('Придумай свою сказку!', style: stl, textScaleFactor: 1.5, textAlign: TextAlign.center,),
              SizedBox(height:10),
//              Text('Злой телефонный вирус немного поменял известную с детства сказу.', style: stl, textAlign: TextAlign.center,),
//              Text('Если хотите услышать правильный вариант - восстановить её по памяти.', style: stl, textAlign: TextAlign.center,),
//              Text('Или придумайте свой вариант!', style: stl, textAlign: TextAlign.center,),
              //Text('Я уверен, ты можешь придумать сказку намного интересней чем та, которую придумал телефон.', style: stl, textAlign: TextAlign.center),
              //Text('Нажми на слово, которое хочешь заменить, и внизу появятся варианты, доступные для замены.', style: stl, textAlign: TextAlign.center),
              //Text('Выбирай один из них - и сказка изменится!', style: stl, textAlign: TextAlign.center,),
              //Text('Слова-замены можно добавлять и удалять!', style: stl, textAlign: TextAlign.center),
              //Text('Не забывайте иногда послушать то, что получилось)', style: stl, textAlign: TextAlign.center,),
              //Text('И поделись с друзьями!!!', style: stl, textAlign: TextAlign.center,),
              RichText(
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(text: 'Я уверен, ты можешь придумать сказку намного интересней чем та, которую придумал телефон.'
                        '\n\nНажми на слово, которое хочешь заменить, и внизу появятся варианты, доступные для замены.'
                        '\n\nСлова-замены можно добавлять и изменять ('),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.edit),
                      ),
                    ),
                    TextSpan(text: ')'
                        '\n\nВыбирай одно из них - и сказка изменится!'
                        '\nНе забывайте иногда послушать ('),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.play_arrow),
                      ),
                    ),
                    TextSpan(text: ') то, что получилось)'),
                    TextSpan(text: '\nСказку можно сохранить ('),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.save_alt),
                      ),
                    ),
                    TextSpan(text: ') и потом прочитать ('),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.restore_page),
                      ),
                    ),
                    TextSpan(text: ')'
                        '\nА также отправить другу! '),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.language),
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(text: 'Значёк '),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.import_contacts),
                      ),
                    ),
                    TextSpan(text: '(сверху, справа) позволяет поменять основную сказку.'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Автор идеи и разработчик - \nПрихоженко Владимир.', style: TextStyle(fontSize: 16, color: Colors.green[900],), textAlign: TextAlign.center,),
              Text('Вопросы и пожелания шлите на е-мейл vprihogenko@gmail.com', style: TextStyle(fontSize: 16, color: Colors.green[900],), textAlign: TextAlign.center,),
              SizedBox(height: 20),
              FloatingActionButton(onPressed: (){
                Navigator.pop(context);
              }, tooltip: 'Назад', child: Text('OK'), heroTag: "btnAboutOk",),
            ] ,
          ),
        ),
      ),
    );
  }
}
