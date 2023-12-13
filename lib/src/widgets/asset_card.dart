import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/asset_data.dart';

class AssetCard extends StatelessWidget {
  final AssetData data;
  final double itemSize;

  const AssetCard({
    super.key,
    required this.data,
    required this.itemSize,
  });

  @override
  Widget build(BuildContext context) {
    final String name = data.path.split('/').last;
    late final Widget child;

    if (name.endsWith('.svg')) {
      child = SvgPicture.asset(data.path);
    } else {
      child = Image.asset(data.path);
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
          SelectableText(
            name,
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Text('(${data.size})'),
        ],
      ),
    );
  }
}
