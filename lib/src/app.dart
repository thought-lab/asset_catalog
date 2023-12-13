import 'package:flutter/material.dart';

import 'pages/main_page.dart';
import 'stores/theme_store.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData?>(
      valueListenable:
          ThemeStore.of(context)?.theme ?? ValueNotifier(ThemeData.dark()),
      builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const MainPage(),
        );
      },
    );
  }
}
