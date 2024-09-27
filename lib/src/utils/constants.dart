import 'package:flutter/services.dart';

class ColorsManager {

  const ColorsManager._();


  static const Color boarder =  Color(0xffe5e7eb);
}

class FormatterManager {

  const FormatterManager._();


  static  TextInputFormatter plusSign =  _PlusSignInputFormatter();
}

class _PlusSignInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.text.startsWith('+')) {
      return TextEditingValue(
        text: '+${newValue.text}',
        selection: TextSelection.collapsed(offset: newValue.text.length + 1),
      );
    }
    return newValue;
  }
}