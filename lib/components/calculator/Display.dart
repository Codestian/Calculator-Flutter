import 'package:calculator/components/calculator/ExpressionHistory.dart';
import 'package:calculator/models/calculator_history.dart';
import 'package:flutter/material.dart';

class Display extends StatefulWidget {
  final FixedExtentScrollController scrollController;
  final List<CalculatorHistoryModel> historyList;
  final void Function(int index) onSelectedItemChanged;

  const Display({
    super.key,
    required this.scrollController,
    required this.historyList,
    required this.onSelectedItemChanged,
  });
  @override
  State<Display> createState() => DisplayState();
}

class DisplayState extends State<Display> {
  int selectedHistory = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedHistory = widget.historyList.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
        child: Stack(
          children: <Widget>[
              ExpressionHistory(
                scrollController: widget.scrollController,
                historyList: widget.historyList,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedHistory = index;
                  });
                  widget.onSelectedItemChanged(index);
                },
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(
                widget.historyList[selectedHistory].result,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 48,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
