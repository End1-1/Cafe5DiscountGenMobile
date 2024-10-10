import 'package:cviewdiscount/config.dart';

final Map<String, Map<String, String>> vals = {
  'am': {
    'yes': 'Այո',
    'no': 'Ոչ',
    'armenian': 'Հայերեն',
    'english': 'English',
    'russian': 'Русский',
    'sign in': 'Մուտք',
    'login': 'Մուտք',
    'logout': 'Ելք',
    'unknown': 'Անհայտ',
    'confirm to logout': 'Հաստատեք ելքը',
    'cancel': 'Հրաժարվել',
    'generate': 'Ստեղցել նոր զեղչի քարտ',
    'create new discount card?': 'Ստեղծել՞ նոր զեղչի քարտ',
    'send link': 'Ուղարկել',
    'bonuses': 'Բոնուսներ',
    'empty qr code': 'Դատարկ կոդ',
    'next': 'Առաջ',
    'confirm': 'Հաստատել',
    'phone number': 'Հեռախոսի համարը',
    'code from sms': 'SMS-ով ուղարկած կոդը',
    'no connection to server.\ncheck internet connection.': 'Հնարավոր չէ կապ հաստատել սերվերի հետ։\nՍտուգեք ինտերնետի առկայությունը։',
    'phone number cannot be empty': 'Հեռախոսի համարը նշված չէ',
    'if no sms received, please, entered check phone number': 'Եթե SMS չի եկել, ստուգեք մուտքագրված հեռախոսահամարը',
    'wrong credential entered': 'Մուտքագրված տվյալները սխալ են',
    'code': 'կոդ',
    'change number': 'փոխել հեռախոսահամարը',
    'language':'Լեզու'
  },
  'ru': {
    'yes': 'Да',
    'no': 'Нет',
    'armenian': 'Հայերեն',
    'english': 'English',
    'russian': 'Русский',
    'sign in': 'Вход',
    'login': 'Вход',
    'logout': 'Выход',
    'unknown': 'Неизвестно',
    'confirm to logout': 'Подтвердите выход',
    'cancel': 'Отмена',
    'generate': 'Создать новый код',
    'create new discount card?': 'Подтвердите создание нового кода',
    'send link': 'Поделиться',
    'bonuses': 'Бонусы',
    'empty qr code': 'Пустой код',
    'next': 'Вперёд',
    'confirm': 'Подтвердить',
    'phone number': 'Телефонный номер',
    'code from sms': 'Введите код из SMS',
    'no connection to server.\ncheck internet connection.': 'Невозможно подключиться к серверу, проверте интернет.',
    'phone number cannot be empty': 'Введите номер телефона',
    'if no sms received, please, entered check phone number': 'Если не получили СМС, проверте введённый номер и интерет.',
    'wrong credential entered': 'Введены неверные данные',
    'code': 'код',
    'change number': 'изменить телефонный номер',
    'language':'Язык'
  }
};

String tr(String s) {
  return Translator.tr(s);
}

class Translator {
  static String tr(String s) {
    if (!vals.containsKey(Config.getLanguage())) {
      return s;
    }
    if (vals[Config.getLanguage()]!.containsKey(s.toLowerCase())) {
      return vals[Config.getLanguage()]![s.toLowerCase()]!;
    }
    return s;
  }
}
