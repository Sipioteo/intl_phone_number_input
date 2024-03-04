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

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(_listener);
    super.initState();
  }

  List<String> _remainsZero = List.generate(10, (index) => '0').toList();
  String previousText = '';

  void _listener() {
    String currentText = _controller.text;

    if (previousText.length > currentText.length) {
      // Backspace pressed
      _remainsZero
          .replaceRange(currentText.length, currentText.length + 1, ['0']);
    } else if (previousText.length < currentText.length) {
      // New character pressed
      // _remainsZero.replaceRange(currentText.length - 1, currentText.length, [currentText.split('').last]);
      _remainsZero.replaceRange(
          currentText.length - 1, currentText.length, [''.padLeft(1)]);
    }
    String finalStr = _remainsZero.reduce((value, element) {
      return value + element;
    });

    setState(() {
      _hintText = finalStr;
    });
    // _controller.text= '9999999999';

    previousText = currentText;
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
            TextFormField(
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              enabled: false,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 1.7,
              ),
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: _hintText,
                hintStyle: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1.7,
                ),
                suffixText: ''.padLeft(_controller.text.length * 2),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              textDirection: TextDirection.rtl,
              controller: _controller,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18,
                letterSpacing: 2,
              ),
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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

