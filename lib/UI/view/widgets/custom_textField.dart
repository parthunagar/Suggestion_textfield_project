import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pkg_text_field/UI/suggest_textfield/database/databasehelper.dart';
import 'package:pkg_text_field/UI/suggest_textfield/model/suggetion_api_model.dart';
import 'package:pkg_text_field/UI/view/widgets/controller.dart';
import 'dart:developer' as logger;
import 'package:pkg_text_field/UI/view/widgets/overlay_container.dart';
import 'package:pkg_text_field/UI/view/widgets/rich_text.dart';
import 'package:pkg_text_field/const/constat.dart';

typedef OnTap = void Function(String? index);

class DictionaryTextField extends StatefulWidget {
  ValueChanged<String>? onChange;
  String? initialValue;
  FocusNode? focusNode;
  InputDecoration? decoration = const InputDecoration();
  TextInputType? keyboardType;
  TextCapitalization textCapitalization = TextCapitalization.none;
  TextInputAction? textInputAction;
  TextStyle? style;
  StrutStyle? strutStyle;
  TextDirection? textDirection;
  TextAlign textAlign = TextAlign.start;
  TextAlignVertical? textAlignVertical;
  bool autofocus = false;
  bool readOnly = false;
  ToolbarOptions? toolbarOptions;
  bool? showCursor;
  String obscuringCharacter = '•';
  bool obscureText = false;
  bool autocorrect = true;
  SmartDashesType? smartDashesType;
  SmartQuotesType? smartQuotesType;
  bool enableSuggestions = true;
  bool maxLengthEnforced = true;
  MaxLengthEnforcement? maxLengthEnforcement;
  int? maxLines = 1;
  int? minLines;
  bool expands = false;
  int? maxLength;
  GestureTapCallback? onTap;
  VoidCallback? onEditingComplete;
  ValueChanged<String>? onFieldSubmitted;
  FormFieldSetter<String>? onSaved;
  FormFieldValidator<String>? validator;
  List<TextInputFormatter>? inputFormatters;
  bool? enabled;
  double cursorWidth = 2.0;
  double? cursorHeight;
  Radius? cursorRadius;
  Color? cursorColor;
  Brightness? keyboardAppearance;
  EdgeInsets scrollPadding = const EdgeInsets.all(20.0);
  bool enableInteractiveSelection = true;
  TextSelectionControls? selectionControls;
  InputCounterWidgetBuilder? buildCounter;
  ScrollPhysics? scrollPhysics;
  Iterable<String>? autofillHints;
  AutovalidateMode? autovalidateMode;
  ScrollController? scrollController;
  String? restorationId;
  bool? enableIMEPersonalizedLearning;
  int? maxElementsToDisplay;
  OnTap? onChangeValue;
  Decoration? listDecoration, itemDecoration;
  TextStyle? listItemStyle;
  double? listHeight, listWidth;
  Color? selectedTextColor, unSelectedTextColor;
  bool showSuggestionList;
  double? listItemFontSize;
  EdgeInsetsGeometry? itemPadding, itemMargin;
  String? selectedFontFamily, unSelectedFontFamily;
  double? itemHeight, itemWidth;
  DropdownPosition? position;

  DictionaryTextField({
    Key? key,
    this.onTap,
    this.onEditingComplete,
    this.onSaved,
    this.enabled = true,
    this.scrollController,
    this.enableIMEPersonalizedLearning,
    this.onChangeValue,
    this.maxElementsToDisplay = 5,
    this.listDecoration,
    this.listItemStyle,
    this.listHeight,
    this.listWidth,
    this.selectedTextColor,
    this.unSelectedTextColor,
    this.showSuggestionList = false,
    this.decoration,
    this.listItemFontSize,
    this.itemPadding,
    this.itemMargin,
    this.itemDecoration,
    this.selectedFontFamily,
    this.unSelectedFontFamily,
    this.itemHeight,
    this.itemWidth,
    this.position = DropdownPosition.BELOW,
    this.focusNode,
  }) : super(key: key);

  @override
  State<DictionaryTextField> createState() => _DictionaryTextFieldState();
}

class _DictionaryTextFieldState extends State<DictionaryTextField> {
  CustomController? cSearch = CustomController();
  bool isItemClicked = false;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<String> names = [];

  List addText = [];
  String? suggestString = '';

  OverlayEntry? entry;
  final layerLink = LayerLink();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.focusNode = FocusNode();
    controllerListener();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showOverlay();
    });
    focusNodeListener();
  }

  controllerListener() {
    cSearch!.addListener(() async {
      addText = cSearch!.text.split(' ');
      debugPrint('onChanged => addText : $addText');

      /// GET ONLY TYPED VALUE
      // var a = cSearch!.text.substring(0, cSearch!.text.length);
      // debugPrint('onChangedVal.substring => a : $a');
      // debugPrint('onChangedVal.substring => a.length : ${a.length}');
      // if(cSearch!.text.endsWith(' ')){
      //   suggestString = '';
      //   debugPrint("cSearch!.text.endsWith(' ') : ${cSearch!.text.endsWith(' ')}");
      // }
      // else

      // debugPrint('addText : ${addText.last}');
      // debugPrint('addText.runtimeType : ${addText.last.runtimeType}');
      if (cSearch!.text.length > 1 &&
          cSearch!.text.substring(cSearch!.text.length - 1) == ' ') {
        names.clear();
        suggestString = '';
        cSearch!.suggestText = '';
        // debugPrint('names =======> 1 : $names');
        // debugPrint('suggestString =======> 1 : $suggestString');
      } else {
        try {
          // debugPrint('addText.last : ${addText.last}');
          await dbHelper.getDataWithQuery(addText.last).then((value) {
            if (value != null) {
              names.clear();
              for (var f in value) {
                // debugPrint('f : $f');
                var a = Dictionary.fromMap(f);
                names.add(a.word.toString());
              }
            }
            // debugPrint('names : ${names}');
          });
          var getFirstValue = names[0];
          // debugPrint('getFirstValue : $getFirstValue'); //Apple
          suggestString = getFirstValue.substring(
              addText.last.length, getFirstValue.length);

          // debugPrint('suggestString : $suggestString'); //pple
        } catch (e) {
          suggestString = '';
          debugPrint('onChanged => ERROR : $e');
        }

        // debugPrint('suggestString.length : ${suggestString!.length}');
        // debugPrint('addText : ${addText}');
        if (cSearch!.text.isEmpty) {
          cSearch!.suggestText = '';
        } else {
          if (addText.last == '') {
            cSearch!.suggestText = '';
          } else {
            cSearch!.suggestText = suggestString;
          }
        }

        var index1 = cSearch!.text.toLowerCase().lastIndexOf(' ');
        // debugPrint('index1 : $index1');
        if (names.length > widget.maxElementsToDisplay!) {
          // debugPrint('names.length: ${names.length}');
          names = names.sublist(0, widget.maxElementsToDisplay);
        }
        // debugPrint('addListener => names : $names');
      }
      // debugPrint('names => $names');
      // debugPrint('addText => $addText');
      entry!.markNeedsBuild();
      setState(() {});
    });
  }

  focusNodeListener() {
    widget.focusNode!.addListener(() {
      if (widget.focusNode!.hasFocus) {
        showOverlay();
      } else {
        hideOverLay();
      }
    });
  }

  Widget buildOverLay() {
    return Const.ifelse(
      widget.showSuggestionList == false,
      valid: const SizedBox(),
      invalid: _BuildOverLayWidget(
        listHeight: widget.listHeight,
        listDecoration: widget.listDecoration,
        itemCount: names.length,
        itemBuilder: (context, index) {
          return _OverLayItems(
            onTap: () {
              addText.last = names[index];
              cSearch!.text = addText.join(' ');
              debugPrint('onTap =>  cSearch!.text : ${cSearch!.text}');
              suggestString = '';
              debugPrint('onTap => addText : ${addText}');
              debugPrint('onTap => addText.last : ${addText.last}');
              names.clear();
              cSearch!.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: cSearch!.text.length,
                ),
              );
              setState(() {});
            },
            itemDecoration: widget.itemDecoration,
            index: index,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            itemPadding: widget.itemPadding,
            itemMargin: widget.itemMargin,
            title: names[index].substring(0, addText.last.length),
            titleFontSize: widget.listItemFontSize,
            titleColor: widget.selectedTextColor,
            titleFontFamily: widget.selectedFontFamily,
            hint: names[index]
                .substring(addText.last.length, names[index].length),
            hintFontSize: widget.listItemFontSize,
            hintColor: widget.unSelectedTextColor,
            hintFontFamily: widget.unSelectedFontFamily,
          );
        },
      ),
    );
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offSet = renderBox.localToGlobal(Offset.zero);
    entry = OverlayEntry(
      builder: (context) => Positioned(
        // left: offSet.dx,
        // right: offSet.dy + size.height + 8,
        width: size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          // offset: Offset(0,size.height),
          offset: Offset(0, size.height * 1.05),
          child: buildOverLay(),
        ),
      ),
    );
    overlay!.insert(entry!);
  }

  void hideOverLay() {
    entry!.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: TextFormField(
        decoration: widget.decoration ??
            InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade50,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 2,
                ),
              ),
            ),
        restorationId: widget.restorationId,
        controller: cSearch,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textDirection: widget.textDirection,
        textCapitalization: widget.textCapitalization,
        autofocus: widget.autofocus,
        toolbarOptions: widget.toolbarOptions,
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType ??
            (widget.obscureText
                ? SmartDashesType.disabled
                : SmartDashesType.enabled),
        smartQuotesType: widget.smartQuotesType ??
            (widget.obscureText
                ? SmartQuotesType.disabled
                : SmartQuotesType.enabled),
        enableSuggestions: widget.enableSuggestions,
        // maxLengthEnforcement: widget.maxLengthEnforced,

        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        onChanged: (String? val) {
          widget.onChangeValue!(val);
        },
        onTap: widget.onTap ?? () {},
        onEditingComplete: () => widget.onEditingComplete ?? () {},
        onFieldSubmitted: widget.onFieldSubmitted ??
            (val) {
              // widget.focusNode!.unfocus();
              // hideOverLay();
            },
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled ?? widget.decoration?.enabled ?? true,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        scrollPadding: widget.scrollPadding,
        scrollPhysics: widget.scrollPhysics,
        keyboardAppearance: widget.keyboardAppearance,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectionControls: widget.selectionControls,
        buildCounter: widget.buildCounter,
        autofillHints: widget.autofillHints,
        scrollController: widget.scrollController,
        enableIMEPersonalizedLearning:
            widget.enableIMEPersonalizedLearning ?? true,
        onSaved: (onSavedVal) => widget.onSaved ?? (onSavedVal) {},
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cSearch!.dispose();
  }
}

class _BuildOverLayWidget extends StatelessWidget {
  double? listHeight;
  Decoration? listDecoration;
  int? itemCount;
  Widget Function(BuildContext, int) itemBuilder;

  _BuildOverLayWidget({
    Key? key,
    @required this.listHeight,
    @required this.listDecoration,
    @required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: listHeight ?? MediaQuery.of(context).size.height * 0.7,
      // width: widget.listWidth,
      // alignment: Alignment.topLeft,
      // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      // margin: EdgeInsets.symmetric(),
      decoration: listDecoration ??
          BoxDecoration(
            color: Colors.grey.shade600,
          ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        // itemBuilder: itemBuilder ??  (context, index) {
        itemBuilder: itemBuilder,
      ),
    );
  }
}

class _OverLayItems extends StatelessWidget {
  void Function()? onTap;
  Decoration? itemDecoration;
  int? index;
  double? itemHeight, itemWidth;
  EdgeInsetsGeometry? itemPadding;
  EdgeInsetsGeometry? itemMargin;

  String? title, hint;
  double? titleFontSize, hintFontSize;
  Color? titleColor, hintColor;
  String? titleFontFamily, hintFontFamily;

  _OverLayItems({
    Key? key,
    @required this.onTap,
    @required this.itemDecoration,
    @required this.index,
    @required this.itemHeight,
    @required this.itemWidth,
    @required this.itemPadding,
    @required this.itemMargin,
    required this.title,
    required this.titleFontSize,
    required this.titleColor,
    required this.titleFontFamily,
    required this.hint,
    required this.hintFontSize,
    required this.hintColor,
    required this.hintFontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: itemDecoration ??
            BoxDecoration(
              // color: index! % 2 == 0 ? Colors.grey[200] : Colors.white,
              color: Const.ifelse(
                index! % 2 == 0,
                valid: Colors.grey[200],
                invalid: Colors.white,
              ),
            ),
        height: itemHeight,
        width: itemWidth,
        padding: itemPadding ??
            const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
        margin: itemMargin ??
            const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
        child: RichTextWidget(
          title: title,
          titleFontSize: titleFontSize,
          titleColor: titleColor,
          titleFontFamily: titleFontFamily,
          hint: hint,
          hintFontSize: hintFontSize,
          hintColor: hintColor,
          hintFontFamily: hintFontFamily,
        ),
      ),
    );
  }
}
