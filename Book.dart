class Book {
  static final Set<String> _usedIsbns = {}; 
  String title;
  String author;
  int year;
  String genre;
  String isbn;
  bool isLent;
  String? lentTo;
  DateTime? dueDate;

  Book({
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    required String isbn, 
    this.isLent = false,
    this.lentTo,
    this.dueDate,
  }) : this.isbn = _validateAndAddIsbn(isbn);
  
  static String _validateAndAddIsbn(String isbn) {
    if (_usedIsbns.contains(isbn)) {
      throw ArgumentError('ISBN must be unique. The provided ISBN is already used.');
    }
    _usedIsbns.add(isbn);
    return isbn;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'year': year,
        'genre': genre,
        'isbn': isbn,
        'isLent': isLent,
        'lentTo': lentTo,
        'dueDate': dueDate?.toIso8601String(),
      };

  static Book fromJson(Map<String, dynamic> json) {
    final book = Book(
      title: json['title'],
      author: json['author'],
      year: json['year'],
      genre: json['genre'],
      isbn: json['isbn'],
      isLent: json['isLent'],
      lentTo: json['lentTo'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );

    _validateAndAddIsbn(book.isbn);
    return book;
  }

  @override
  String toString() {
    return 'Title: $title, Author: $author, Year: $year, Genre: $genre, ISBN: $isbn, Lent: $isLent';
  }
}