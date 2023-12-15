enum MenuSortingType {
  name,
  size;

  String get getDisplayedValue {
    switch (this) {
      case MenuSortingType.name:
        return 'Name';
      case MenuSortingType.size:
      default:
        return 'Size';
    }
  }
}
