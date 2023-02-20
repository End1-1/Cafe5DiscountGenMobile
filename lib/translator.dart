import 'package:cviewdiscount/config.dart';

final Map<String, Map<String, String>> vals = {
  'am': {
    'yes': 'Այո',
    'no': 'Ոչ',
    'sign in': 'Մուտք',
    'login': 'Մուտք',
    'update date': 'Թարմացնել տվյալները',
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
    'phone number': 'Հեռախոսի մարարը',
    'code from sms': 'SMS-ով ուղարկած կոդը',
    'no connection to server.\ncheck internet connection.': 'Հնարավոր չէ կապ հաստատել սերվերի հետ։\nՍտուգեք ինտերնետի առկայությունը։',
    'phone number cannot be empty': 'Հեռախոսի համարը նշված չէ',
    'if no SMS received, please, entered check phone number': 'Եթե SMS չի եկել, ստուգեք մուտքագրված հեռախոսահամարը',
    'wrong credential entered': 'Մուտքագրված տվյալները սխալ են'
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
