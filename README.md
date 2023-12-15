Asset documentation tools for flutter projects

<p align="center">
  <img src="https://github.com/thought-lab/asset_catalog/blob/v0.2.0-meta/resources/ss_example_light_v0.2.0.png?raw=true" alt="light screenshot" width="75%" />
</p>

## Usage

Add `asset_catalog` as `dev_depencency` on main/app package


```
dev_dependencies:
  flutter_test:
    sdk: flutter
  asset_catalog: ^0.1.0
```

Create file `tools/asset_catalog.dart` with code below as the app entry point
```
import 'package:asset_catalog/asset_catalog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AssetCatalog());
}

```

Run on web browser for better experience, so ensure your app has activate web platform
```
flutter run -t tools/asset_catalog.dart -d chrome
```

