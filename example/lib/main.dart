import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text('Demo')),
          // body: AbberApp(),
          body: MyTextField(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState?.validate();
              },
              child: Text('Validate'),
            ),
            ElevatedButton(
              onPressed: () {
                getPhoneNumber('+15417543010');
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState?.save();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AbberApp extends StatelessWidget {
  const AbberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                // printLog(number.phoneNumber);
              },
              onInputValidated: (bool value) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                trailingSpace: false,
                useEmoji: false,
                // useBottomSheetSafeArea: true,
                showFlags: true,
                setSelectorButtonAsPrefixIcon: true,
              ),
              countrySelectorScrollControlled: true,
              autoFocusSearch: false,
              ignoreBlank: true,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: const TextStyle(color: Colors.black),
              // initialValue: number,
              // textFieldController: controller,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputBorder: const OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late final TextEditingController _controller;

  String _hintText = '';

  int maxDigit = 10;
  late List<String> _remainsZero;
  String previousText = '';

  @override
  void initState() {
    String input = "1234567890123456";
    String format = "00 0000 0000 0000";

    String formattedText = applyFormat(input, format);
    print(formattedText); // Output: "1234 5678 9012 3456"



    _remainsZero = List.generate(maxDigit, (index) => '0').toList();
    _controller = TextEditingController();
    _controller.addListener(_listener);
    String finalStr = _remainsZero.reduce((value, element) {
      return value + element;
    });
    _hintText = finalStr;

    super.initState();
  }


  void _listener() {
    String currentText = _controller.text.replaceAll('  ', '');
    if(currentText.length > maxDigit){
      return;
    }
    else if (previousText.length > currentText.length) {
      // Backspace pressed
      _remainsZero
          .replaceRange(currentText.length, currentText.length + 1, ['0']);
    } else if (previousText.length < currentText.length) {
      // type a new char
      _remainsZero.replaceRange(
          currentText.length - 1, currentText.length, [''.padLeft(1)]);
    }

     if(currentText.length <= maxDigit){
      String finalStr = _remainsZero.reduce((value, element) {
        return value + element;
      });

      setState(() {
        _hintText = finalStr;
      });
      previousText = currentText;
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 8),
        // color: Colors.red.withOpacity(0.4),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        height: 50,
        child: Stack(
          children: [
            // TextFormField(
            //   keyboardType: TextInputType.number,
            //   textDirection: TextDirection.ltr,
            //   enabled: false,
            //   textAlign: TextAlign.left,
            //   style: TextStyle(
            //     fontSize: 18,
            //     letterSpacing: 1.7,
            //   ),
            //   onTapOutside: (event) =>
            //       FocusManager.instance.primaryFocus?.unfocus(),
            //   decoration: InputDecoration(
            //       hintText: _hintText,
            //       hintStyle: TextStyle(
            //         fontSize: 18,
            //         letterSpacing: 2,
            //       ),
            //       suffixText: ''.padLeft(
            //           _controller.text.replaceAll('  ', '').length * 2),
            //       border: InputBorder.none,
            //       contentPadding: EdgeInsets.zero),
            // ),
            TextFormField(
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              controller: _controller,
              textAlign: TextAlign.left,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              inputFormatters: [
                DynamicCardNumberInputFormatter('0 00 000 0000 000000'),
              ],
              style: TextStyle(
                fontSize: 18,
                letterSpacing: -2,
                // backgroundColor: Colors.red,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }



}


class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = removeArabicNumbers(newValue.text);

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var formattedText = _formatCardNumber(text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCardNumber(String input) {
    input = input.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    var buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      buffer.write(input[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 1 == 0 && nonZeroIndex != input.length) {
        // Add double spaces
        buffer.write('  ');
      }
    }
    return buffer.toString();
  }
}

class DynamicCardNumberInputFormatter extends TextInputFormatter {
  final String format;

  DynamicCardNumberInputFormatter(this.format);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digits

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var formattedText = _formatText(text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }


  String _formatText(String input) {
    var buffer = StringBuffer();
    int formatIndex = 0;

    for (int i = 0; i < input.length; i++) {
      // Skip over spaces in the format string
      if (i > 0) {
        buffer.write(' ');
      }

      // Append the input character
      while (formatIndex < format.length && format[formatIndex] == ' ') {
        buffer.write('  ');
        formatIndex++;
      }

      if (i >= input.length) {
        break;
      }

      buffer.write(input[i]);
      formatIndex++;
    }

    return buffer.toString();
  }



}




String removeArabicNumbers(String text) => text
    .replaceAll('١', '1')
    .replaceAll('٢', '2')
    .replaceAll('٣', '3')
    .replaceAll('٤', '4')
    .replaceAll('٥', '5')
    .replaceAll('٦', '6')
    .replaceAll('٧', '7')
    .replaceAll('٨', '8')
    .replaceAll('٩', '9')
    .replaceAll('٠', '0');


String applyFormat(String input, String format) {
  String formattedText = '';
  int count = 0;

  for (int i = 0; i < input.length; i++) {
    if (count >= format.length) {
      break; // Exit loop if we reach the end of the format string
    }

    if (format[count] == '0') {
      formattedText += input[i];
    } else {
      formattedText += format[count]; // Add the format character
      formattedText += input[i]; // Add the input character
    }

    count++;

    // Add a space if the next character in the format is a space
    if (count < format.length && format[count] == ' ') {
      formattedText += ' ';
      count++;
    }
  }

  return formattedText;
}
