
class Author {
  String name;
  DateTime dob;
  List<String> booksWritten;

  Author({
    required this.name,
    required this.dob,
    required this.booksWritten,
  });

  // Computed property to generate a unique ID
  String get uniqueId => '${name}_${dob.toIso8601String()}';

  Map<String, dynamic> toJson() => {
        'name': name,
        'dob': dob.toIso8601String(),
        'booksWritten': booksWritten,
        'uniqueId': uniqueId,
      };

  static Author fromJson(Map<String, dynamic> json) => Author(
        name: json['name'],
        dob: DateTime.parse(json['dob']),
        booksWritten: List<String>.from(json['booksWritten']),
      );

  @override
  String toString() {
    return 'Name: $name, DOB: $dob, Books: ${booksWritten.join(', ')}, Unique ID: $uniqueId';
  }
}
