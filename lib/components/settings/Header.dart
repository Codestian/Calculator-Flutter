import 'package:flutter/material.dart';

Widget Header(String title, {bool isPro = false}) => Row(
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        if (isPro) Text("TEST"),
      ],
    );
