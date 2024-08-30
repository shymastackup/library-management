
import 'library.dart';
import 'dart:io';

void main() async {
  final libraryManager = LibraryManager();
  await libraryManager.loadData();

  while (true) {
    print('Library Management System');
    print('1. Add Book');
    print('2. View Books');
    print('3. Update Book');
    print('4. Delete Book');
    print('5. Search Books');
    print('6. Lend Book');
    print('7. Return Book');
    print('8. Add Author');
    print('9. View Authors');
    print('10. Update Author');
    print('11. Delete Author');
    print('12. Add Member');
    print('13. View Members');
    print('14. Update Member');
    print('15. Delete Member');
    print('16. Save and Exit');

    stdout.write('Choose an option: ');
    final option = stdin.readLineSync()!.trim();

    switch (option) {
      case '1':
        await libraryManager.addBook();
        break;
      case '2':
        libraryManager.viewBooks();
        break;
      case '3':
        stdout.write('Enter ISBN of the book to update: ');
        final isbn = stdin.readLineSync()!.trim();
        if (isbn.isEmpty) {
          print('ISBN cannot be empty.');
        } else {
          await libraryManager.updateBook(isbn);
        }
        break;
      case '4':
        stdout.write('Enter ISBN of the book to delete: ');
        final isbn = stdin.readLineSync()!.trim();
        if (isbn.isEmpty) {
          print('ISBN cannot be empty.');
        } else {
          await libraryManager.deleteBook(isbn);
        }
        break;
      case '5':
        stdout.write('Enter search query: ');
        final query = stdin.readLineSync()!.trim();
        if (query.isEmpty) {
          print('Search query cannot be empty.');
        } else {
          libraryManager.searchBooks(query);
        }
        break;
      case '6':
        stdout.write('Enter ISBN of the book to lend: ');
        final isbn = stdin.readLineSync()!.trim();
        stdout.write('Enter member ID: ');
        final memberId = stdin.readLineSync()!.trim();
        if (isbn.isEmpty || memberId.isEmpty) {
          print('ISBN and Member ID cannot be empty.');
        } else {
          await libraryManager.lendBook(isbn, memberId);
        }
        break;
      case '7':
        stdout.write('Enter ISBN of the book to return: ');
        final isbn = stdin.readLineSync()!.trim();
        if (isbn.isEmpty) {
          print('ISBN cannot be empty.');
        } else {
          await libraryManager.returnBook(isbn);
        }
        break;
      case '8':
        await libraryManager.addAuthor();
        break;
      case '9':
        libraryManager.viewAuthors();
        break;
      case '10':
        stdout.write('Enter the name of the author to update: ');
        final name = stdin.readLineSync()!.trim();
        if (name.isEmpty) {
          print('Author name cannot be empty.');
        } else {
          await libraryManager.updateAuthor(name);
        }
        break;
      case '11':
        stdout.write('Enter the name of the author to delete: ');
        final name = stdin.readLineSync()!.trim();
        if (name.isEmpty) {
          print('Author name cannot be empty.');
        } else {
          await libraryManager.deleteAuthor(name);
        }
        break;
      case '12':
        await libraryManager.addMember();
        break;
      case '13':
        libraryManager.viewMembers();
        break;
      case '14':
        stdout.write('Enter member ID to update: ');
        final memberId = stdin.readLineSync()!.trim();
        if (memberId.isEmpty) {
          print('Member ID cannot be empty.');
        } else {
          await libraryManager.updateMember(memberId);
        }
        break;
      case '15':
        stdout.write('Enter member ID to delete: ');
        final memberId = stdin.readLineSync()!.trim();
        if (memberId.isEmpty) {
          print('Member ID cannot be empty.');
        } else {
          await libraryManager.deleteMember(memberId);
        }
        break;
      case '16':
        print('Saved and exit');
        await libraryManager.saveData();
        return;
      default:
        print('Invalid option. Try again.');
    }
  }
}
