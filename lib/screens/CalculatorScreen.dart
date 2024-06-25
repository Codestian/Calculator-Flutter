import 'package:calculator/components/calculator/Display.dart';
import 'package:calculator/components/calculator/ExpressionHistory.dart';
import 'package:calculator/components/calculator/KeyPad.dart';
import 'package:calculator/models/calculator_history.dart';
import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/screens/SettingsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class CalculatorScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CalculatorScreen> createState() => CalculatorScreenState();
}

class CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final FixedExtentScrollController scrollController =
      FixedExtentScrollController();
  int selectedHistory = 0;

  final List<CalculatorHistoryModel> _history = [
    CalculatorHistoryModel(expression: "2+2", result: "4"),
    CalculatorHistoryModel(expression: "5*6", result: "30"),
    CalculatorHistoryModel(expression: "2+2", result: "4"),
    CalculatorHistoryModel(expression: "5*6+cos(90)", result: "30"),
    CalculatorHistoryModel(expression: "", result: ""),
  ];

  void handleEquals() {
    String tempResult =
        _history[selectedHistory].expression.replaceAll('÷', '/');

    String tempResult1 =
        convertRootExpression(tempResult.replaceAll('π', 'pi'));

    // SIN COS TAN USES RADIANS
    print(tempResult1);

    if (RegExp(r'[+\/*-^]|sin|cos|tan|pi').hasMatch(tempResult1)) {
      Parser p = Parser();

      try {
        Expression exp = p.parse(tempResult1);
        ContextModel cm = ContextModel();
        cm.bindVariable(Variable('pi'), Number(math.pi));
        cm.bindVariable(Variable('e'), Number(math.e));
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        _history[selectedHistory].result = eval.toString();
      } catch (e) {
        print(e);
        _history[selectedHistory].result = "ERR";
      }
    }
  }

  void handleBackspace(bool isLatestExpression) {
    if (isLatestExpression) {
      _history[selectedHistory].expression =
          removeLastCharacter(_history[selectedHistory].expression);
      _history[selectedHistory].result = "";
    } else {
      if ((_history[_history.length - 1].result.isEmpty) ||
          _history[_history.length - 1].result == "ERR") {
        _history[_history.length - 1].expression =
            removeLastCharacter(_history[selectedHistory].expression);
        _history[selectedHistory].result = "";
      } else {
        _history.add(
          CalculatorHistoryModel(
              expression:
                  removeLastCharacter(_history[selectedHistory].expression),
              result: ""),
        );
      }

      moveToLatest();
    }
  }

  void handleClear(bool isLatestExpression) {
    if (isLatestExpression) {
      _history[selectedHistory] =
          CalculatorHistoryModel(expression: "", result: "");
    } else {
      if (_history[_history.length - 1].result.isEmpty ||
          _history[_history.length - 1].result == "ERR") {
        _history[_history.length - 1].expression = '';
      } else {
        _history.add(CalculatorHistoryModel(expression: "", result: ""));
      }
      moveToLatest();
    }
  }

  void handleDefault(bool isLatestExpression, String text) {
    CalculatorHistoryModel latestExpression = _history[_history.length - 1];

    String finalText = text;

    // If either sin,cos,tan, append (.
    if (RegExp(r'^(sin|cos|tan)$').hasMatch(text)) {
      finalText += "(";
    }

    if (text == "n√") {
      finalText = "root(";
    }

    // If result is empty, this means it must be latest expression.
    if (_history[selectedHistory].result.isEmpty) {
      latestExpression.expression += finalText;
    }
    // Means its a past expression.
    else {
      // Checks if text is not the 4 operations with power. Don't bring forward result.
      if (!RegExp(r'[+\-÷*^]').hasMatch(text)) {
        // If latest expression result is empty, means its not complete, replace it.
        if (latestExpression.result.isEmpty || latestExpression.result == "ERR") {
          latestExpression.expression = finalText;
        }
        // If latest expression already has result, create new one.
        else {
          _history.add(
            CalculatorHistoryModel(
              expression: finalText,
              result: "",
            ),
          );
        }
      }
      // This means text is one of 4 operations or power.
      else {
        if (isLatestExpression) {
          _history.add(
            CalculatorHistoryModel(
              expression: _history[selectedHistory].result + finalText,
              result: "",
            ),
          );
        } else {
          if (latestExpression.result.isEmpty || latestExpression.result == "ERR") {
            latestExpression.expression =
                _history[selectedHistory].result + finalText;
          } else {
            _history.add(
              CalculatorHistoryModel(
                expression: _history[selectedHistory].result + finalText,
                result: "",
              ),
            );
          }
        }
      }
    }
    moveToLatest();
  }

  void moveToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateToItem(_history.length - 1,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            ref.watch(settingsThemeModeProvider)
                ? Color.alphaBlend(Colors.white.withOpacity(0.15),
                    Colors.black.withOpacity(0.05))
                : Color.alphaBlend(Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.05)),
            Colors.black.withOpacity(0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              trailing: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ),
            Display(
              scrollController: scrollController,
              historyList: _history,
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedHistory = index;
                });
              },
            ),
            KeyPad(
              inputText: (String text) {
                bool isLatestExpression =
                    selectedHistory == _history.length - 1;

                setState(() {
                  switch (text) {
                    case "=":
                      handleEquals();
                      break;
                    case "cursorBack":
                      break;
                    case "cursorForward":
                      break;
                    case "C":
                      handleClear(isLatestExpression);
                      break;
                    case "backspace":
                      handleBackspace(isLatestExpression);
                      break;
                    default:
                      handleDefault(isLatestExpression, text);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

String removeLastCharacter(String str) {
  if (str.isEmpty) {
    return str;
  } else {
    if (str.length >= 4 &&
        RegExp(r'^(sin\(|cos\(|tan\()$')
            .hasMatch(str.substring(str.length - 4))) {
      return str.substring(0, str.length - 4);
    } else if (str.length >= 5 &&
        RegExp(r'^root\($').hasMatch(str.substring(str.length - 5))) {
      return str.substring(0, str.length - 5);
    } else {
      return str.substring(0, str.length - 1);
    }
  }
}

String convertRootExpression(String input) {
  final regExp = RegExp(r'root\(([^,]+),\s*([^)]+)\)');
  return input.replaceAllMapped(regExp, (match) {
    final x = match.group(1);
    final n = match.group(2);
    return '($x^(1/$n))';
  });
}
