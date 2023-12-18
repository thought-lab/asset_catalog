import 'dart:math';

class AssetData {
  final String path;
  final int size;
  final String package;
  final String resolution;

  const AssetData({
    required this.path,
    required this.size,
    required this.package,
    required this.resolution,
  });

  String get sizeDisplayed => _getFileSizeString(bytes: size);
  String get fileName => path.split('/').last;
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
