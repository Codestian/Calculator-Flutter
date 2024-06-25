import 'package:calculator/components/calculator/KeyButton.dart';
import 'package:calculator/enums/key_color_enums.dart';
import 'package:flutter/material.dart';

class KeyPad extends StatefulWidget {
  final Function(String) inputText;

  const KeyPad({
    super.key,
    required this.inputText,
  });

  @override
  State<KeyPad> createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [GlobalKey(), GlobalKey()];
  bool isSecondFunction = false;
  double sidePadding = 8;

  void scrollToNext() {
    if (_scrollController.hasClients) {
      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double itemHeight = maxScrollExtent / (_keys.length - 1);

      double targetScroll = currentScroll + itemHeight;
      if (targetScroll > maxScrollExtent) {
        targetScroll = maxScrollExtent;
      }

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

      setState(() {
        isSecondFunction = true;
      });
    }
  }

  void scrollToPrevious() {
    if (_scrollController.hasClients) {
      double currentScroll = _scrollController.position.pixels;
      double itemHeight =
          _scrollController.position.maxScrollExtent / (_keys.length - 1);

      double targetScroll = currentScroll - itemHeight;
      if (targetScroll < 0) {
        targetScroll = 0;
      }

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

      setState(() {
        isSecondFunction = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void inputText(String text) {
    if (text == "fn" || text == "#") {
      if (isSecondFunction) {
        scrollToPrevious();
      } else {
        scrollToNext();
      }
    } else {
            scrollToPrevious();

      widget.inputText(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(sidePadding),
      child: Column(
        children: <Widget>[
          FirstRow(inputText, isSecondFunction),
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: <Widget>[
                SizedBox(
                    key: _keys[0],
                    width:
                        MediaQuery.of(context).size.width - (sidePadding * 2),
                    child: Column(
                      children: <Widget>[
                        SecondRowOne(inputText),
                        ThirdRowOne(inputText),
                        FourthRowOne(inputText),
                        FifthRowOne(inputText),
                      ],
                    )),
                SizedBox(
                    key: _keys[1],
                    width:
                        MediaQuery.of(context).size.width - (sidePadding * 2),
                    child: Column(
                      children: <Widget>[
                        SecondRowTwo(inputText),
                        ThirdRowTwo(inputText),
                        FourthRowTwo(inputText),
                        FifthRowTwo(inputText),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget FirstRow(Function inputText, bool isSecondFunction) => Row(
      children: <Widget>[
        KeyButton(
          text: isSecondFunction ? '#' : 'fn',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'cursorBack',
          color: KeyColor.operator,
          icon: Icons.arrow_back_ios_new,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'cursorForward',
          color: KeyColor.operator,
          icon: Icons.arrow_forward_ios,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'C',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'backspace',
          color: KeyColor.operator,
          icon: Icons.arrow_back,
          onTap: (String text) => inputText(text),
        ),
      ],
    );

Widget SecondRowOne(Function inputText) => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        KeyButton(
          text: '7',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '8',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '9',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '(',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: ')',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
      ],
    );

Widget ThirdRowOne(Function inputText) => Row(
      children: <Widget>[
        KeyButton(
          text: '4',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '5',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '6',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '*',
          color: KeyColor.action,
          icon: Icons.close,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '÷',
          color: KeyColor.action,
          onTap: (String text) => inputText(text),
        ),
      ],
    );

Widget FourthRowOne(Function inputText) => Row(
      children: <Widget>[
        KeyButton(
          text: '1',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '2',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '3',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '+',
          color: KeyColor.action,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '-',
          color: KeyColor.action,
          onTap: (String text) => inputText(text),
        ),
      ],
    );

Widget FifthRowOne(Function inputText) => Row(
      children: <Widget>[
        KeyButton(
            text: '0',
            color: KeyColor.number,
            onTap: (String text) => inputText(text),
            flex: 2,
            aspectRatio: 2 / 1),
        KeyButton(
          text: '.',
          color: KeyColor.number,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
            text: '=',
            color: KeyColor.action,
            onTap: (String text) => inputText(text),
            flex: 2,
            aspectRatio: 2 / 1),
      ],
    );

Widget SecondRowTwo(Function inputText) => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        KeyButton(
          text: '^',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'sin',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'cos',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'tan',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'π',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
      ],
    );

Widget ThirdRowTwo(Function inputText) => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        KeyButton(
          text: 'e',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '√',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: '∛',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'n√',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: ',',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
      ],
    );

Widget FourthRowTwo(Function inputText) => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        KeyButton(
          text: '^',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'sin',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'cos',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'tan',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'π',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
      ],
    );

Widget FifthRowTwo(Function inputText) => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        KeyButton(
          text: '^',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'sin',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'cos',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'tan',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
        KeyButton(
          text: 'π',
          color: KeyColor.operator,
          onTap: (String text) => inputText(text),
        ),
      ],
    );
