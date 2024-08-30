import 'dart:convert';
import 'dart:io';
import 'Book.dart';
import 'author.dart';
import 'member.dart';
import 'library.dart';

class DataPersistence {
  final LibraryManager libraryManager;
  DataPersistence(this.libraryManager);
  Future<void> saveData() async {
    try {
      var booksJson = jsonEncode(libraryManager.books);
      var authorsJson = jsonEncode(libraryManager.authors);
      var membersJson = jsonEncode(libraryManager.members);

      await File('books.json').writeAsString(booksJson);
      await File('authors.json').writeAsString(authorsJson);
      await File('members.json').writeAsString(membersJson);

      print('Data saved successfully.');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> loadData() async {
    try {
      var booksJson = await File('books.json').readAsString();
      var authorsJson = await File('authors.json').readAsString();
      var membersJson = await File('members.json').readAsString();

      var bookList = jsonDecode(booksJson) as List;
      var authorList = jsonDecode(authorsJson) as List;
      var memberList = jsonDecode(membersJson) as List;

      libraryManager.books =
          bookList.map((book) => Book.fromJson(book)).toList();
      libraryManager.authors =
          authorList.map((author) => Author.fromJson(author)).toList();
      libraryManager.members =
          memberList.map((member) => Member.fromJson(member)).toList();

      print('Data loaded successfully.');
    } catch (e) {
      print('Error loading data: $e');
    }
  }
}