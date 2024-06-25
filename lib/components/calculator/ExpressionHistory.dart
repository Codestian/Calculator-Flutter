import 'package:calculator/models/calculator_history.dart';
import 'package:flutter/material.dart';

class ExpressionHistory extends StatefulWidget {
  final FixedExtentScrollController scrollController;
  final List<CalculatorHistoryModel> historyList;
  final void Function(int index) onSelectedItemChanged;

  const ExpressionHistory({
    super.key,
    required this.scrollController,
    required this.historyList,
    required this.onSelectedItemChanged,
  });

  @override
  State<ExpressionHistory> createState() => _ExpressionHistopryState();
}

class _ExpressionHistopryState extends State<ExpressionHistory> {
  final double _rowHeight = 40;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.jumpToItem(widget.historyList.length - 1);
    });
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  double _getFontSize(int index) {
    int centerIndex = widget.scrollController.selectedItem;
    return index == centerIndex ? 32.0 : 20.0;
  }

  Color _getFontColor(int index) {
    int centerIndex = widget.scrollController.selectedItem;
    return index == centerIndex ? Theme.of(context).colorScheme.secondary : Colors.white.withOpacity(0.4);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListWheelScrollView.useDelegate(
        controller: widget.scrollController,
        itemExtent: _rowHeight,
        physics: const FixedExtentScrollPhysics(),
        overAndUnderCenterOpacity: 1.0,
        perspective: 0.00001,
        onSelectedItemChanged: (index) {
          setState(() {
            widget.onSelectedItemChanged(index);
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= widget.historyList.length) {
              return null;
            }
            double fontSize = _getFontSize(index);
            Color fontColor = _getFontColor(index);
            CalculatorHistoryModel item = widget.historyList[index];
            return Container(
              height: _rowHeight,
              alignment: Alignment.center,
              child: TextField(
                controller: TextEditingController(
                  text: item.expression,
                ),
                style: TextStyle(
                  fontSize: fontSize,
                  color: fontColor,
                ),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
              ),
            );
          },
          childCount: widget.historyList.length,
        ),
      ),
    );
  }
}
