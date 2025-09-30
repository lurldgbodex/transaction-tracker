class Optional<T> {
  final T? _value;
  final bool _isPresent;

  const Optional.value(T value) : _value = value, _isPresent = true;

  const Optional.absent() : _value = null, _isPresent = false;

  T? get value => _isPresent ? _value : null;
  bool get isPresent => _isPresent;
}
