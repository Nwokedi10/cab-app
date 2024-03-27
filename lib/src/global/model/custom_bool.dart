class TwinBool {
  final bool a, b;

  const TwinBool({this.a = false, this.b = false});

  bool get isTrue => a && b;
}
