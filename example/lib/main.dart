import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:hint_form_field/hint_form_field.dart';

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
      home: Scaffold(
        appBar: AppBar(title: Text('Demo')),
        body: AbberApp(),
        // body: PinCodeVerificationScreen(),
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

// class HintFormField extends StatefulWidget {
//
//   final Color? hintColor;
//   final Color? textColor;
//   final double? fontSize;
//   final InputBorder? border;
//   final String hintFormat;
//
//
//   const HintFormField({
//     super.key,
//     this.hintColor,
//     this.textColor,
//     this.fontSize,
//     this.border,
//     required this.hintFormat,
//   });
//
//   @override
//   State<HintFormField> createState() => _HintFormFieldState();
// }
//
// class _HintFormFieldState extends State<HintFormField> {
//
//   late final TextEditingController _controller;
//   String _hintText = '';
//   String _previousText = '';
//
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//     _formatterHint();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _formatterHint() {
//     _AppFormatter.mask = widget.hintFormat;
//     setState(() {
//       _hintText = widget.hintFormat.replaceAll('#', '0');
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: InputDecorator(
//         isEmpty: true,
//         textAlign: TextAlign.left,
//         decoration: InputDecoration(
//           hintText: _hintText,
//           hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
//             color: widget.hintColor??Colors.grey ,
//             fontFeatures: [FontFeature.tabularFigures()],
//             fontSize: widget.fontSize,
//
//           ),
//           hintTextDirection: TextDirection.ltr,
//           border: widget.border,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 8,
//             vertical: 0
//           ),
//         ),
//         child: TextField(
//           keyboardType: TextInputType.number,
//           textAlign: TextAlign.left,
//           controller: _controller,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//           ),
//
//           textDirection: TextDirection.ltr,
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             fontFeatures: [FontFeature.tabularFigures()],
//             color: widget.textColor,
//             fontSize: widget.fontSize,
//           ),
//           inputFormatters: [
//             _AppFormatter.maskFormatter,
//           ],
//           onChanged: _onChanged,
//         ),
//       ),
//     );
//   }
//
//   void _onChanged(String value) {
//     final baseOffset = _controller.selection.baseOffset;
//     if (value.length < _previousText.length) {
//       String result = _hintText;
//       List<int> spaceIndices = [];
//       int currentIndex = _previousText.indexOf(' ');
//       while (currentIndex != -1) {
//         spaceIndices.add(currentIndex);
//         currentIndex = _previousText.indexOf(' ', currentIndex + 1);
//       }
//       if (spaceIndices.isEmpty) {
//         result = _hintText.replaceRange(baseOffset, baseOffset + 1, '0');
//       } else if (spaceIndices.last != baseOffset) {
//         result = _hintText.replaceRange(baseOffset, baseOffset + 1, '0');
//       } else {
//         result = _hintText.replaceRange(baseOffset + 1, baseOffset + 2, '0');
//       }
//       _hintText = result;
//     } else {
//       String result = _hintText.replaceRange(
//           baseOffset - 1, baseOffset, value.split('').last);
//       _hintText = result;
//     }
//     _previousText = value;
//     setState(() {});
//   }
// }
//
//
// class _AppFormatter {
//   static String mask = '';
//   static TextInputFormatter maskFormatter = MaskTextInputFormatter(
//     mask: mask,
//     // filter: {"#": RegExp(r'[0-9]')},
//     // filter: {"#": RegExp(r'[0-9۰-۹]')},
//     type: MaskAutoCompletionType.lazy,
//   );
// }
