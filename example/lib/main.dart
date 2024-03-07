import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mask/mask.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
          // body: PinCodeVerificationScreen(),
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
  late final TextEditingController _controller2;
  String _hintText2 = '';

  @override
  void initState() {
    _controller2 = TextEditingController();
    _getFormatHintText(formatHint);
    AppFormatter.mask = formatHint;
    super.initState();
  }

  @override
  void dispose() {
    _controller2.dispose();
    super.dispose();
  }

  String formatHint = '# ### ## #### ##';

  void _getFormatHintText(String input) {
    String replacedAll = input.replaceAll('#', '0');
    setState(() {
      _hintText2 = replacedAll;
    });
  }

  String previousText2 = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: InputDecorator(
          isEmpty: true,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: _hintText2,
            hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            hintTextDirection: TextDirection.ltr,
            border: InputBorder.none,
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.left,
            controller: _controller2,
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            inputFormatters: [
              AppFormatter.maskFormatter,
            ],
            onChanged: (value) {
              final baseOffset = _controller2.selection.baseOffset;
              if (value.length < previousText2.length) {
                String result = _hintText2;
                List<int> spaceIndices = [];
                int currentIndex = previousText2.indexOf(' ');
                while (currentIndex != -1) {
                  spaceIndices.add(currentIndex);
                  currentIndex = previousText2.indexOf(' ', currentIndex + 1);
                }
                // print("Index of space: $spaceIndices");
                // print("baseOffset: $baseOffset");
                if(spaceIndices.isEmpty){
                  result = _hintText2.replaceRange(
                      baseOffset, baseOffset + 1, '0');
                  print("Replace first");
                }
                else if(spaceIndices.last != baseOffset){
                  print("Replace");
                  result = _hintText2.replaceRange(
                      baseOffset, baseOffset + 1, '0');
                }
                else {
                  print("Skip");
                  result = _hintText2.replaceRange(
                            baseOffset + 1, baseOffset + 2, '0');

                }
                // String result = _hintText2;
                // check where index of space
                // for(var char in previousText2.split('')){
                //   if (char == ' ') {
                //     print('SKIP OVER SPACE ');
                //
                //     result = _hintText2.replaceRange(
                //         baseOffset + 1, baseOffset + 2, '0');
                //     break;
                //   } else {
                //     print('REPLACE ');
                //
                //     result = _hintText2.replaceRange(
                //         baseOffset, baseOffset + 1, '0');
                //   }
                //
                // }
                _hintText2 = result;
              }

              else {
                String result = _hintText2.replaceRange(
                    baseOffset - 1, baseOffset, value.split('').last);
                _hintText2 = result;
              }
              previousText2 = value;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}

class AppFormatter {
  static String mask = '';

  static TextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: mask,
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  static TextInputFormatter maskFormatter2 = Mask.generic(
    masks: [mask],
    hashtag: Hashtag.numbers,
  );
}
