import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsIsProVersionProvider =
    NotifierProvider<SettingsIsProVersionValue, bool>(
        SettingsIsProVersionValue.new);

class SettingsIsProVersionValue extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void set(bool isFirstTime) {
    state = isFirstTime;
  }
}

final settingsThemeModeProvider =
    NotifierProvider<SettingsThemeModeValue, bool>(SettingsThemeModeValue.new);

class SettingsThemeModeValue extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void setLight() {
    state = false;
  }

  void setDark() {
    state = true;
  }

  void set(bool isLuminant) {
    state = isLuminant;
  }
}

final settingsThemePrimaryProvider =
    NotifierProvider<SettingsThemePrimaryValue, Color>(
        SettingsThemePrimaryValue.new);

class SettingsThemePrimaryValue extends Notifier<Color> {
  @override
  Color build() {
    return Colors.orange;
  }

  void setDefaultThemeDefault() {
    state = Colors.orange;
  }

  void setCusomTheme(Color color) {
    state = color;
  }
}

final settingsEnableMaterialYouProvider =
    NotifierProvider<SettingsEnableMaterialYouValue, bool>(
        SettingsEnableMaterialYouValue.new);

class SettingsEnableMaterialYouValue extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void set(bool format) {
    if (format) {
      state = true;
    } else {
      state = false;
    }
  }
}
