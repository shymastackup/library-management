import 'dart:io';
import 'dart:convert';
import 'Book.dart';
import 'author.dart';
import 'member.dart';

class LibraryManager {
  List<Book> books = [];
  List<Author> authors = [];
  List<Member> members = [];


  Future<void> loadData() async {
    try {
      final booksFile = File('books.json');
      if (await booksFile.exists()) {
        final booksData = jsonDecode(await booksFile.readAsString());
        books = (booksData as List)
            .map((bookJson) => Book.fromJson(bookJson))
            .toList();
      }

      final authorsFile = File('authors.json');
      if (await authorsFile.exists()) {
        final authorsData = jsonDecode(await authorsFile.readAsString());
        authors = (authorsData as List)
            .map((authorJson) => Author.fromJson(authorJson))
            .toList();
      }

      final membersFile = File('members.json');
      if (await membersFile.exists()) {
        final membersData = jsonDecode(await membersFile.readAsString());
        members = (membersData as List)
            .map((memberJson) => Member.fromJson(memberJson))
            .toList();
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> saveData() async {
    try {
      final booksFile = File('books.json');
      await booksFile
          .writeAsString(jsonEncode(books.map((b) => b.toJson()).toList()));

      final authorsFile = File('authors.json');
      await authorsFile
          .writeAsString(jsonEncode(authors.map((a) => a.toJson()).toList()));

      final membersFile = File('members.json');
      await membersFile
          .writeAsString(jsonEncode(members.map((m) => m.toJson()).toList()));
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> addBook() async {
    try {
      final title = _getValidInput('Enter book title: ');
      final author = _getValidInput('Enter author: ');
      final year = _getValidIntInput('Enter publication year: ');
      final genre = _getValidInput('Enter genre: ');
      final isbn = _getValidInput('Enter ISBN: ');

      books.add(Book(
          title: title, author: author, year: year, genre: genre, isbn: isbn));
      await saveData();
      print('Book added successfully.');
    } catch (e) {
      print('Error adding book: $e');
    }
  }

  void viewBooks() {
    if (books.isEmpty) {
      print('No books available.');
    } else {
      for (var book in books) {
        print(book);
      }
    }
  }

  Future<void> updateBook(String isbn) async {
    try {
      final book = books.firstWhere((b) => b.isbn == isbn,
          orElse: () => throw Exception('Book not found.'));
      stdout.write('Enter new title (leave empty to keep unchanged): ');
      final title = stdin.readLineSync();
      stdout.write('Enter new author (leave empty to keep unchanged): ');
      final author = stdin.readLineSync();
      stdout.write(
          'Enter new publication year (leave empty to keep unchanged): ');
      final yearInput = stdin.readLineSync();
      stdout.write('Enter new genre (leave empty to keep unchanged): ');
      final genre = stdin.readLineSync();

      if (title != null && title.isNotEmpty) book.title = title;
      if (author != null && author.isNotEmpty) book.author = author;
      if (yearInput != null && yearInput.isNotEmpty)
        book.year = int.parse(yearInput);
      if (genre != null && genre.isNotEmpty) book.genre = genre;

      await saveData();
      print('Book updated.');
    } catch (e) {
      print('Error updating book: $e');
    }
  }

  Future<void> deleteBook(String isbn) async {
    try {
      books.removeWhere((b) => b.isbn == isbn);
      await saveData();
      print('Book deleted.');
    } catch (e) {
      print('Error deleting book: $e');
    }
  }

  void searchBooks(String query) {
    final results = books.where((book) =>
        book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase()) ||
        book.genre.toLowerCase().contains(query.toLowerCase()));

    if (results.isEmpty) {
      print('No books found.');
    } else {
      for (var book in results) {
        print(book);
      }
    }
  }

  Future<void> lendBook(String isbn, String memberId) async {
    try {
      final book = books.firstWhere((b) => b.isbn == isbn,
          orElse: () => throw Exception('Book not found.'));
      if (book.isLent) {
        print('Book is already lent.');
        return;
      }

      final member = members.firstWhere((m) => m.memberId == memberId,
          orElse: () => throw Exception('Member not found.'));
      stdout.write('Enter due date (YYYY-MM-DD): ');
      final dueDate = DateTime.parse(stdin.readLineSync()!);

      book.isLent = true;
      book.lentTo = memberId;
      book.dueDate = dueDate;
      member.borrowedBooks.add(book.isbn);

      await saveData();
      print(
          'Book lent to ${member.name}, due on ${dueDate.toIso8601String()}.');
    } catch (e) {
      print('Error lending book: $e');
    }
  }

  Future<void> returnBook(String isbn) async {
    try {
      final book = books.firstWhere((b) => b.isbn == isbn,
          orElse: () => throw Exception('Book not found.'));
      if (!book.isLent) {
        print('Book is not currently lent.');
        return;
      }

      final member = members.firstWhere((m) => m.memberId == book.lentTo,
          orElse: () => throw Exception('Member not found.'));

      book.isLent = false;
      book.lentTo = null;
      book.dueDate = null;
      member.borrowedBooks.remove(book.isbn);

      await saveData();
      print('Book returned.');
    } catch (e) {
      print('Error returning book: $e');
    }
  }

  Future<void> addAuthor() async {
    try {
      final name = _getValidInput('Enter author name: ');
      final dob = _getValidDateInput('Enter author date of birth (YYYY-MM-DD): ');
      stdout.write('Enter books written by author (comma separated): ');
      final booksWritten =
          stdin.readLineSync()!.split(',').map((b) => b.trim()).toList();

      authors.add(Author(name: name, dob: dob, booksWritten: booksWritten));
      await saveData();
      print('Author added successfully.');
    } catch (e) {
      print('Error adding author: $e');
    }
  }

  void viewAuthors() {
    if (authors.isEmpty) {
      print('No authors available.');
    } else {
      for (var author in authors) {
        print(author);
      }
    }
  }

  Future<void> updateAuthor(String name) async {
    try {
      final author = authors.firstWhere((a) => a.name == name,
          orElse: () => throw Exception('Author not found.'));
      stdout.write('Enter new name (leave empty to keep unchanged): ');
      final newName = stdin.readLineSync();
      stdout.write('Enter new date of birth (leave empty to keep unchanged): ');
      final dobInput = stdin.readLineSync();
      stdout.write(
          'Enter new books written (comma separated, leave empty to keep unchanged): ');
      final booksInput = stdin.readLineSync();

      if (newName != null && newName.isNotEmpty) author.name = newName;
      if (dobInput != null && dobInput.isNotEmpty)
        author.dob = DateTime.parse(dobInput);
      if (booksInput != null && booksInput.isNotEmpty)
        author.booksWritten =
            booksInput.split(',').map((b) => b.trim()).toList();

      await saveData();
      print('Author updated.');
    } catch (e) {
      print('Error updating author: $e');
    }
  }

  Future<void> deleteAuthor(String name) async {
    try {
      authors.removeWhere((a) => a.name == name);
      await saveData();
      print('Author deleted.');
    } catch (e) {
      print('Error deleting author: $e');
    }
  }

  Future<void> addMember() async {
    try {
      final name = _getValidInput('Enter member name: ');
      final memberId = _getValidInput('Enter member ID: ');
      stdout.write('Enter borrowed books (comma separated): ');
      final borrowedBooks =
          stdin.readLineSync()!.split(',').map((b) => b.trim()).toList();

      members.add(
          Member(name: name, memberId: memberId, borrowedBooks: borrowedBooks));
      await saveData();
      print('Member added successfully.');
    } catch (e) {
      print('Error adding member: $e');
    }
  }

  void viewMembers() {
    if (members.isEmpty) {
      print('No members available.');
    } else {
      for (var member in members) {
        print(member);
      }
    }
  }

  Future<void> updateMember(String memberId) async {
    try {
      final member = members.firstWhere((m) => m.memberId == memberId,
          orElse: () => throw Exception('Member not found.'));
      stdout.write('Enter new name (leave empty to keep unchanged): ');
      final name = stdin.readLineSync();
      stdout.write(
          'Enter new borrowed books (comma separated, leave empty to keep unchanged): ');
      final booksInput = stdin.readLineSync();

      if (name != null && name.isNotEmpty) member.name = name;
      if (booksInput != null && booksInput.isNotEmpty)
        member.borrowedBooks =
            booksInput.split(',').map((b) => b.trim()).toList();

      await saveData();
      print('Member updated.');
    } catch (e) {
      print('Error updating member: $e');
    }
  }

  Future<void> deleteMember(String memberId) async {
    try {
      members.removeWhere((m) => m.memberId == memberId);
      await saveData();
      print('Member deleted.');
    } catch (e) {
      print('Error deleting member: $e');
    }
  }

  // Helper methods for input validation
  String _getValidInput(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync();
      if (input != null && input.isNotEmpty) {
        return input;
      }
      print('Invalid input. Please try again.');
    }
  }

  int _getValidIntInput(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync();
      try {
        return int.parse(input!);
      } catch (_) {
        print('Invalid number. Please enter a valid integer.');
      }
    }
  }

  DateTime _getValidDateInput(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync();
      try {
        return DateTime.parse(input!);
      } catch (_) {
        print('Invalid date. Please enter a valid date in YYYY-MM-DD format.');
      }
    }
  }
}