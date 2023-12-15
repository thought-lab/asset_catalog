enum MenuGroupingType {
  none,
  package;

  String get getDisplayedValue {
    switch (this) {
      case MenuGroupingType.package:
        return 'Package';
      case MenuGroupingType.none:
      default:
        return 'None';
    }
  }
}
