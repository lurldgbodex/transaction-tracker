class ActiveFilter {
  final String type;
  final String displayName;
  final dynamic value;

  const ActiveFilter({
    required this.type,
    required this.displayName,
    this.value,
  });
}
