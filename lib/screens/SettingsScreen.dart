import 'package:calculator/components/common/TitleBar.dart';
import 'package:calculator/components/settings/sections/AppThemeSection.dart';
import 'package:calculator/components/settings/Header.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const TitleBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Header('App theme'),
            const SizedBox(height: 16),
            const AppThemeSection()
          ],
        ),
      ),
    );
  }
}
