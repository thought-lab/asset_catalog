library asset_catalog;

import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/stores/theme_store.dart';

class AssetCatalog extends StatelessWidget {
  const AssetCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeStore(
      child: const App(),
    );
  }
}
