import 'package:cviewdiscount/config.dart';

final Map<String, Map<String, String>> vals = {
  'am': {
    'yes': 'Այո',
    'no': 'Ոչ',
    'sign in': 'Մուտք',
    'login': 'Մուտք',
    'username or password incorrect': 'Գաղտնաբառը կամ օգտագործողը սխալ է',
    'tasks': 'Առցանց պատվեր',
    'update date': 'Թարմացնել տվյալները',
    'logout': 'Ելք',
    'enter the customer name': 'Մուտքագրեք հաճախորդի անունը',
    'car plate number': 'Պետհամարանիշ',
    "car model": "Մեքենաի մատնիշ",
    "customer name": "Հաճախորդի անուն",
    "customer phone number": "Հաճախորդի հեռախոսահամար",
    'unknown': 'Անհայտ',
    'confirm to logout': 'Հաստատեք ելքը',
    'cancel': 'Հրաժարվել',
    'quantity of ': 'Քանակ',
    'print bill': 'Տպել հաշիվը',
    'generate': 'Ստեղցել նոր զեղչի քարտ',
    'create new discount card?': 'Ստեղծել՞ նոր զեղչի քարտ',
    'send link': 'Ուղարկել',
    'bonuses': 'Բոնուսներ',
    'empty qr code': 'Դատարկ կոդ'
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
