import 'dart:io';

import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final IconButton? action;

  const TitleBar({
    Key? key,
    required this.title,
    this.showBack = false,
    this.action,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(Platform.isIOS ? 44 : 56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: Platform.isIOS ? true : false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withOpacity(0.2),
            height: 2.0,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: Platform.isIOS ? 16 : 20,
            fontWeight: Platform.isIOS ? FontWeight.w700 : FontWeight.w800,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: action != null ? action! : const SizedBox(),
          )
        ],
        leading: showBack
            ? IconButton(
                icon: Icon(Platform.isIOS
                    ? Icons.arrow_back_ios_new
                    : Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null);
  }
}
