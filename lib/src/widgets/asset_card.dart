import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/asset_data.dart';

class AssetCard extends StatelessWidget {
  final AssetData data;
  final double itemSize;
  final bool isShowPackageName;

  const AssetCard({
    super.key,
    required this.data,
    required this.itemSize,
    this.isShowPackageName = false,
  });

  @override
  Widget build(BuildContext context) {
    final String name = data.fileName;
    String desc = '(${data.sizeDisplayed})';

    late final Widget child;

    if (name.endsWith('.svg')) {
      child = SvgPicture.asset(data.path);
    } else {
      child = Image.asset(data.path);
      desc = '${data.resolution} $desc';
    }

    return Container(
      width: itemSize + 16,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: itemSize,
            width: itemSize,
            child: child,
          ),
          const SizedBox(height: 12),
          _buildPackageLabel(),
          SelectableText(
            name,
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageLabel() {
    if (!isShowPackageName) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text('${data.package}/'),
    );
  }
}
