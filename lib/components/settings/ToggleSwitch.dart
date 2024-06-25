import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final String title;
  final bool value;
  final void Function(bool value) onChanged;
  final bool isPro;

  const ToggleSwitch(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChanged,
      this.isPro = false})
      : super(key: key);

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isActive = false;

  void onChanged(bool value) {
    setState(() {
      isActive = value;
    });
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Text(
        widget.title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      const SizedBox(width: 8),
      widget.isPro ? Text('TEST') : const SizedBox(),
      const Spacer(),
      Platform.isIOS
          ? CupertinoSwitch(
              value: isActive,
              onChanged: widget.isPro ? null : onChanged,
              activeColor: Theme.of(context).colorScheme.primary,
            )
          : Switch(
              value: isActive,
              onChanged: widget.isPro ? null : onChanged,
            )
    ]);
  }
}
