import 'package:flutter/material.dart';

class ThemeStore extends InheritedWidget {
  final ValueNotifier<ThemeData> theme = ValueNotifier(ThemeData.dark());

  ThemeStore({super.key, required Widget child}) : super(child: child);

  static ThemeStore? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeStore>();

  void toogleTheme() {
    if (theme.value == ThemeData.light()) {
      theme.value = ThemeData.dark();
    } else {
      theme.value = ThemeData.light();
    }
  }

  @override
  bool updateShouldNotify(ThemeStore oldWidget) => oldWidget.theme != theme;
}
