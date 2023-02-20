import 'dart:ui';

class ColorHelper extends Color {

  const ColorHelper(super.value);

  static get background_color => fromHex("#151B2B");
  static get button_background_gradient1 => fromHex("#3E7EF1");
  static get button_background_gradient2 => fromHex("#295199");

  static get textform_border_color => fromHex("#3E7EF1");
  static get text_color => fromHex("#ffffff");
  static get title_text_color => fromHex("#BB966E");
  static get formfield_text_color => fromHex("#3E7EF1");

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}