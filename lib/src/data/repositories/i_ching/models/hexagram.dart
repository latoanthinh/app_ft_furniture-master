class Hexagram {
  String? code;

  String? get lowerTrigramCode => code?.substring(0, 3);

  String? get upperTrigramCode => code?.substring(3, 6);

  Hexagram({
    this.code,
  });

  factory Hexagram.fromMap(Map<String, dynamic> map) {
    return Hexagram(
      code: map['code'] as String,
    );
  }
}
