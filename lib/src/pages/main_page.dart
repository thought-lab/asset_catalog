import 'dart:math';

import 'package:asset_catalog/src/stores/theme_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../models/asset_data.dart';
import '../widgets/asset_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const String mainPackage = 'app';
  static const List<String> allowedExtension = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'bmp',
    'wbmp',
    'svg',
  ];

  final TextEditingController _searchController = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();

  final Map<String, List<AssetData>> _assetAll = {};
  Map<String, List<AssetData>> _assetDisplayed = {};
  double _itemSize = 250;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssets();
    });

    _searchController.addListener(_search);
  }

  Widget _buildSideBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 0, 32),
      width: 225,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSizeSlider(),
          _buildSearchBar(),
          const SizedBox(height: 24),
          const Text(
            'Packages',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: _assetDisplayed.keys.length,
              itemBuilder: (_, i) {
                final MapEntry<String, List<AssetData>> entry =
                    _assetDisplayed.entries.toList()[i];

                return TextButton(
                  onPressed: () {
                    _itemScrollController.jumpTo(index: i);
                  },
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    '${entry.key} (${entry.value.length})',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 32,
        title: const Text(
          'Asset Catalog',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          _buildThemeSwitcher(),
        ],
      ),
      body: Row(
        children: [
          _buildSideBar(),
          Expanded(
            child: ScrollablePositionedList.separated(
              itemScrollController: _itemScrollController,
              padding: const EdgeInsets.all(32),
              itemCount: _assetDisplayed.entries.length,
              itemBuilder: (_, i) {
                return _buildPackageItems(
                  _assetDisplayed.entries.toList()[i],
                );
              },
              separatorBuilder: (_, i) {
                return const Divider(height: 20);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _buildThemeSwitcher() {
    return ValueListenableBuilder<ThemeData?>(
      valueListenable:
          ThemeStore.of(context)?.theme ?? ValueNotifier(ThemeData.dark()),
      builder: (context, theme, child) {
        final bool isDarkMode = theme == ThemeData.dark();

        return IconButton(
          padding: const EdgeInsets.fromLTRB(8, 8, 32, 8),
          onPressed: () {
            ThemeStore.of(context)?.toogleTheme();
          },
          icon: Icon(
            isDarkMode ? Icons.nightlight : Icons.sunny,
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'find item by name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _clearSearch,
                      child: const Icon(Icons.close),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSlider() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: _itemSize,
          min: 20,
          max: 500,
          onChanged: (double newValue) {
            setState(() {
              _itemSize = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPackageItems(MapEntry<String, List<AssetData>> entry) {
    final String packageName = entry.key;
    final List<AssetData> items = entry.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          packageName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items
              .map(
                (x) => AssetCard(
                  data: x,
                  itemSize: _itemSize,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Future<void> _loadAssets() async {
    final AssetManifest assetManifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);
    final List<String> assetsList =
        assetManifest.listAssets().where(_validateAsset).toList();

    for (String item in assetsList) {
      final int bytes = (await rootBundle.load(item)).lengthInBytes;

      if (item.startsWith('packages')) {
        final String packageName = item.split('/')[1];
        _assetAll.putIfAbsent(packageName, () => []);

        if (item.contains('packages/$packageName')) {
          _assetAll[packageName] = [
            ...?_assetAll[packageName],
            AssetData(
              path: item,
              size: _getFileSizeString(bytes: bytes),
            ),
          ];
        }
        continue;
      }

      // app module
      _assetAll.putIfAbsent(mainPackage, () => []);
      _assetAll[mainPackage] = [
        ...?_assetAll[mainPackage],
        AssetData(
          path: item,
          size: _getFileSizeString(bytes: bytes),
        ),
      ];
    }

    _assetDisplayed = Map.from(_assetAll);
    setState(() {});
  }

  void _search() {
    final String query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _assetDisplayed = Map.from(_assetAll);
      });
      return;
    }

    _assetDisplayed.clear();

    for (MapEntry entry in _assetAll.entries) {
      final List<AssetData> filteredItems = [];

      for (AssetData item in entry.value) {
        final String itemName = item.path.split('/').last;
        if (itemName.contains(query)) {
          filteredItems.add(item);
        }
      }

      if (filteredItems.isNotEmpty) {
        _assetDisplayed[entry.key] = filteredItems;
      }
    }
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    _assetDisplayed = Map.from(_assetAll);
    setState(() {});
  }

  bool _validateAsset(String value) {
    final String extension = value.toLowerCase().split('.').last;
    if (allowedExtension.contains(extension)) {
      return true;
    }

    return false;
  }

  String _getFileSizeString({
    required int bytes,
    int decimals = 2,
  }) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    final int i = (log(bytes) / log(1024)).floor();

    final double result = (bytes / pow(1024, i));
    final String resultString =
        result.toStringAsFixed(result % 1 == 0 ? 0 : decimals);

    return '$resultString ${suffixes[i]}';
  }
}
