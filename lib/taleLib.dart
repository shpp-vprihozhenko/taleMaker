List<String> getKRtale () {
  List <String> krTale = [];

  krTale.add('Жили-были дед да баба.');
  krTale.add('И была у них Курочка Ряба.');
  krTale.add('Снесла курочка яичко.');
  krTale.add('Да не простое - золотое.');
  krTale.add('Дед бил - не разбил.');
  krTale.add('Баба била - не разбила.');
  krTale.add('А мышка бежала,');
  krTale.add('хвостиком махнула,');
  krTale.add('яичко упало и разбилось.');
  krTale.add('Плачет дед, плачет баба');
  krTale.add('и говорит им Курочка Ряба:');
  krTale.add('- Не плачь, дед, не плачь, баба: ');
  krTale.add('снесу я вам новое яичко,');
  krTale.add('не золотое, а простое!');

  return krTale;
}

class Variant {
  int str;
  int wordNum;
  String wordVar;
  Variant(this.str, this.wordNum, this.wordVar);
}

List<List<String>> getOptions2 () {
  return [
    ['Жили-были','Плыли-плыли','Били-били','Летели-летели','Прыгали-прыгали'],
    ['дед','отец','отец','дядя','сосед'],
    ['баба','мама','тётя','дочь','соседка'],
    ['вам','нам','себе','соседскому петуху','первому встречному'],
    ['Курочка','Дудочка','Дурочка','Душечка','Кукушечка'],
    ['Ряба','Рыжая','Синяя','Зелёна','Серо-буро-малиновая'],
    ['Снесла','Принесла','Унесла','Притащила','Стащила'],
    ['яичко','яблочко','кирпичик','ложечка','трактор'],
    ['золотое','серебрянное','деревянное','гнилое','червивое'],
    ['бил','пилил','лизал','чесал','писал'],
    ['разбил','распилил','вылизал','причесал','подписал'],
    ['била','пилила','лизала','чесала','писала'],
    ['разбила','распилила','вылизала','причесала','подписала'],
    ['мышка','кошка','слониниха','блошка','щучка'],
    ['бежала','летела','свистела','хрипела','плыла'],
    ['хвостиком','лапкой','сумочкой','кирпичиком','молоточком'],
    ['махнула','погладила','стукнула','приголубила','проехалась'],
    ['упало','взлетело','зависло','помылось','накрасилось'],
    ['разбилось','погнулось','испачкалось','покатилось','сплющилось'],
    ['Плачет', 'Смеётся', 'Хохочет', 'Радуется', 'Грустит'],
    ['говорит','поёт','свистит','кричит','ворчит',],
    ['плачь','смейся','хохочи','радуйся','грусти'],
    ['Снесу','Принесу','Унесу','Притащу','Стащу'],
    ['новое','старое','грязное','вонючее','пушистое','простое','непростое','гнилое','червивое'],
  ];
}

/*
List<Variant> getOptions () {
  List<Variant> varL = [];
  varL.add(new Variant(0, 0, 'Жили-были'));
  varL.add(new Variant(0, 0, 'Плыли-плыли'));
  varL.add(new Variant(0, 0, 'Били-били'));
  varL.add(new Variant(0, 0, 'Летели-летели'));
  varL.add(new Variant(0, 0, 'Прыгали-прыгали'));

  varL.add(new Variant(0, 1, 'дед'));
  varL.add(new Variant(0, 1, 'сын'));
  varL.add(new Variant(0, 1, 'отец'));
  varL.add(new Variant(0, 1, 'дядя'));
  varL.add(new Variant(0, 1, 'сосед'));

  varL.add(new Variant(0, 3, 'баба'));
  varL.add(new Variant(0, 3, 'мама'));
  varL.add(new Variant(0, 3, 'тётя'));
  varL.add(new Variant(0, 3, 'дочь'));
  varL.add(new Variant(0, 3, 'соседка'));

  varL.add(new Variant(1, 1, 'была'));
  varL.add(new Variant(1, 1, 'жила'));
  varL.add(new Variant(1, 1, 'пела'));
  varL.add(new Variant(1, 1, 'спела'));
  varL.add(new Variant(1, 1, 'вопела'));

  varL.add(new Variant(1, 4, 'Курочка'));
  varL.add(new Variant(1, 4, 'Дудочка'));
  varL.add(new Variant(1, 4, 'Дурочка'));
  varL.add(new Variant(1, 4, 'Душечка'));
  varL.add(new Variant(1, 4, 'Кукушечка'));

  varL.add(new Variant(1, 5, 'Ряба'));
  varL.add(new Variant(1, 5, 'Рыжа'));
  varL.add(new Variant(1, 5, 'Синя'));
  varL.add(new Variant(1, 5, 'Зелёна'));
  varL.add(new Variant(1, 5, 'Серо-буро-малиновая'));

  varL.add(new Variant(2, 0, 'Снесла'));
  varL.add(new Variant(2, 0, 'Принесла'));
  varL.add(new Variant(2, 0, 'Унесла'));
  varL.add(new Variant(2, 0, 'Притащила'));
  varL.add(new Variant(2, 0, 'Стащила'));

  varL.add(new Variant(2, 1, 'Курочка'));
  varL.add(new Variant(2, 1, 'Дудочка'));
  varL.add(new Variant(2, 1, 'Дурочка'));
  varL.add(new Variant(2, 1, 'Душечка'));
  varL.add(new Variant(2, 1, 'Кукушечка'));

  varL.add(new Variant(2, 2, 'яичко'));
  varL.add(new Variant(2, 2, 'яблочко'));
  varL.add(new Variant(2, 2, 'кирпичик'));
  varL.add(new Variant(2, 2, 'чайничек'));
  varL.add(new Variant(2, 2, 'ложечку'));

  varL.add(new Variant(3, 4, 'золотое'));
  varL.add(new Variant(3, 4, 'серебрянное'));
  varL.add(new Variant(3, 4, 'деревянное'));
  varL.add(new Variant(3, 4, 'гнилое'));
  varL.add(new Variant(3, 4, 'червивое'));

  varL.add(new Variant(4, 0, 'дед'));
  varL.add(new Variant(4, 0, 'сын'));
  varL.add(new Variant(4, 0, 'отец'));
  varL.add(new Variant(4, 0, 'дядя'));
  varL.add(new Variant(4, 0, 'сосед'));

  varL.add(new Variant(4, 1, 'бил'));
  varL.add(new Variant(4, 1, 'пилил'));
  varL.add(new Variant(4, 1, 'лизал'));
  varL.add(new Variant(4, 1, 'чесал'));
  varL.add(new Variant(4, 1, 'писал'));

  varL.add(new Variant(4, 4, 'разбил'));
  varL.add(new Variant(4, 4, 'распилил'));
  varL.add(new Variant(4, 4, 'вылизал'));
  varL.add(new Variant(4, 4, 'причесал'));
  varL.add(new Variant(4, 4, 'подписал'));

  varL.add(new Variant(5, 0, 'баба'));
  varL.add(new Variant(5, 0, 'мама'));
  varL.add(new Variant(5, 0, 'тётя'));
  varL.add(new Variant(5, 0, 'дочь'));
  varL.add(new Variant(5, 0, 'соседка'));

  varL.add(new Variant(5, 1, 'била'));
  varL.add(new Variant(5, 1, 'пилила'));
  varL.add(new Variant(5, 1, 'лизала'));
  varL.add(new Variant(5, 1, 'чесала'));
  varL.add(new Variant(5, 1, 'писала'));

  varL.add(new Variant(5, 4, 'разбила'));
  varL.add(new Variant(5, 4, 'распилила'));
  varL.add(new Variant(5, 4, 'вылизала'));
  varL.add(new Variant(5, 4, 'причесала'));
  varL.add(new Variant(5, 4, 'подписала'));

  varL.add(new Variant(6, 1, 'мышка'));
  varL.add(new Variant(6, 1, 'кошка'));
  varL.add(new Variant(6, 1, 'слониниха'));
  varL.add(new Variant(6, 1, 'блошка'));
  varL.add(new Variant(6, 1, 'щука'));

  varL.add(new Variant(6, 2, 'бежала'));
  varL.add(new Variant(6, 2, 'летела'));
  varL.add(new Variant(6, 2, 'свистела'));
  varL.add(new Variant(6, 2, 'хрипела'));
  varL.add(new Variant(6, 2, 'плыла'));

  varL.add(new Variant(7, 0, 'хвостиком'));
  varL.add(new Variant(7, 0, 'лапкой'));
  varL.add(new Variant(7, 0, 'сумочкой'));
  varL.add(new Variant(7, 0, 'кирпичиком'));
  varL.add(new Variant(7, 0, 'молоточком'));

  varL.add(new Variant(7, 1, 'махнула'));
  varL.add(new Variant(7, 1, 'погладила'));
  varL.add(new Variant(7, 1, 'стукнула'));
  varL.add(new Variant(7, 1, 'приголубила'));
  varL.add(new Variant(7, 1, 'проехалась'));

  varL.add(new Variant(8, 0, 'яичко'));
  varL.add(new Variant(8, 0, 'яблочко'));
  varL.add(new Variant(8, 0, 'кирпичик'));
  varL.add(new Variant(8, 0, 'чайничек'));
  varL.add(new Variant(8, 0, 'ложечку'));

  varL.add(new Variant(8, 1, 'упало'));
  varL.add(new Variant(8, 1, 'взлетело'));
  varL.add(new Variant(8, 1, 'зависло'));
  varL.add(new Variant(8, 1, 'помылось'));
  varL.add(new Variant(8, 1, 'покрасилось'));

  varL.add(new Variant(8, 3, 'разбилось'));
  varL.add(new Variant(8, 3, 'склеилось'));
  varL.add(new Variant(8, 3, 'слиплось'));
  varL.add(new Variant(8, 3, 'испачкалось'));
  varL.add(new Variant(8, 3, 'покатилось'));

  varL.add(new Variant(9, 0, 'Плачет'));
  varL.add(new Variant(9, 0, 'Смеётся'));
  varL.add(new Variant(9, 0, 'Хохочет'));
  varL.add(new Variant(9, 0, 'Радуется'));
  varL.add(new Variant(9, 0, 'Грустит'));

  varL.add(new Variant(9, 1, 'дед'));
  varL.add(new Variant(9, 1, 'сын'));
  varL.add(new Variant(9, 1, 'отец'));
  varL.add(new Variant(9, 1, 'дядя'));
  varL.add(new Variant(9, 1, 'сосед'));

  varL.add(new Variant(9, 2, 'Плачет'));
  varL.add(new Variant(9, 2, 'Смеётся'));
  varL.add(new Variant(9, 2, 'Хохочет'));
  varL.add(new Variant(9, 2, 'Радуется'));
  varL.add(new Variant(9, 2, 'Грустит'));

  varL.add(new Variant(9, 3, 'баба'));
  varL.add(new Variant(9, 3, 'мама'));
  varL.add(new Variant(9, 3, 'тётя'));
  varL.add(new Variant(9, 3, 'дочь'));
  varL.add(new Variant(9, 3, 'соседка'));

  varL.add(new Variant(10, 1, 'говорит'));
  varL.add(new Variant(10, 1, 'поёт'));
  varL.add(new Variant(10, 1, 'свистит'));
  varL.add(new Variant(10, 1, 'кричит'));
  varL.add(new Variant(10, 1, 'ворчит'));

  varL.add(new Variant(10, 3, 'Курочка'));
  varL.add(new Variant(10, 3, 'Дудочка'));
  varL.add(new Variant(10, 3, 'Дурочка'));
  varL.add(new Variant(10, 3, 'Душечка'));
  varL.add(new Variant(10, 3, 'Кукушечка'));

  varL.add(new Variant(10, 4, 'Ряба'));
  varL.add(new Variant(10, 4, 'Рыжа'));
  varL.add(new Variant(10, 4, 'Синя'));
  varL.add(new Variant(10, 4, 'Зелёна'));
  varL.add(new Variant(10, 4, 'Серо-буро-малиновая'));

  varL.add(new Variant(11, 2, 'плачь'));
  varL.add(new Variant(11, 2, 'смейся'));
  varL.add(new Variant(11, 2, 'хохочи'));
  varL.add(new Variant(11, 2, 'радуйся'));
  varL.add(new Variant(11, 2, 'грусти'));

  varL.add(new Variant(11, 3, 'дед'));
  varL.add(new Variant(11, 3, 'сын'));
  varL.add(new Variant(11, 3, 'отец'));
  varL.add(new Variant(11, 3, 'дядя'));
  varL.add(new Variant(11, 3, 'сосед'));

  varL.add(new Variant(11, 5, 'плачь'));
  varL.add(new Variant(11, 5, 'смейся'));
  varL.add(new Variant(11, 5, 'хохочи'));
  varL.add(new Variant(11, 5, 'радуйся'));
  varL.add(new Variant(11, 5, 'грусти'));

  varL.add(new Variant(11, 6, 'баба'));
  varL.add(new Variant(11, 6, 'мама'));
  varL.add(new Variant(11, 6, 'тётя'));
  varL.add(new Variant(11, 6, 'дочь'));
  varL.add(new Variant(11, 6, 'соседка'));

  varL.add(new Variant(12, 0, 'Снесу'));
  varL.add(new Variant(12, 0, 'Принесу'));
  varL.add(new Variant(12, 0, 'Унесу'));
  varL.add(new Variant(12, 0, 'Притащу'));
  varL.add(new Variant(12, 0, 'Стащу'));

  varL.add(new Variant(12, 3, 'новое'));
  varL.add(new Variant(12, 3, 'старое'));
  varL.add(new Variant(12, 3, 'грязное'));
  varL.add(new Variant(12, 3, 'вонючее'));
  varL.add(new Variant(12, 3, 'белое'));

  varL.add(new Variant(12, 4, 'яичко'));
  varL.add(new Variant(12, 4, 'яблочко'));
  varL.add(new Variant(12, 4, 'кирпичик'));
  varL.add(new Variant(12, 4, 'чайничек'));
  varL.add(new Variant(12, 4, 'ложечку'));

  varL.add(new Variant(13, 1, 'золотое'));
  varL.add(new Variant(13, 1, 'серебрянное'));
  varL.add(new Variant(13, 1, 'деревянное'));
  varL.add(new Variant(13, 1, 'гнилое'));
  varL.add(new Variant(13, 1, 'червивое'));

  varL.add(new Variant(13, 3, 'простое'));
  varL.add(new Variant(13, 3, 'серебрянное'));
  varL.add(new Variant(13, 3, 'деревянное'));
  varL.add(new Variant(13, 3, 'гнилое'));
  varL.add(new Variant(13, 3, 'червивое'));

  return varL;
}
*/

String getBGpicName() {
 return 'kurRyaba.jpg';
}