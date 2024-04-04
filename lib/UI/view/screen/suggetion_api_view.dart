import 'package:flutter/material.dart';
import 'package:pkg_text_field/UI/view/widgets/custom_textField.dart';

class SuggetionApiPage extends StatefulWidget {
  const SuggetionApiPage({Key? key}) : super(key: key);

  @override
  State<SuggetionApiPage> createState() => _SuggetionApiPageState();
}

class _SuggetionApiPageState extends State<SuggetionApiPage> {
  TextEditingController cDictionary = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suggestion Text field',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        child: ListView(
          children: [
            DictionaryTextField(
              focusNode: focusNode,
              // controller: cDictionary,
              // onChange: (onChangeVal) {
              //   debugPrint('onChangeVal : $onChangeVal');
              // },
              onTap: () {
                debugPrint(' ===========> onTap <=========== ');
              },
              onChangeValue: (onchangeValCustom) {
                debugPrint('onchangeValCustom : $onchangeValCustom');
              },
              maxElementsToDisplay: 50,
              showSuggestionList: true,
            ),
            if(false)
            ListView.builder(
              itemCount: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: const [
                    Text(
                        'as a s as ass  s  as as as as as  as as as as as sa sa sa as  as as as as as as as as as as as as as  as as as as'
                            'as a as  a a  sa as as as as as as as as as  as as as as as  as as as as'),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
