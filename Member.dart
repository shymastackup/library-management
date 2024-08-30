class Member {
  static final Set<String> _usedMemberIds={}; 

  String name;
  String memberId;
  List<String> borrowedBooks;

  Member({
    required this.name,
    required String memberId,
    required this.borrowedBooks,
  }) : this.memberId = _addMemberId(memberId); 

  static String _addMemberId(String memberId) {
    if (_usedMemberIds.contains(memberId)) {
      throw ArgumentError('Member ID must be unique. The provided member ID is already used.');
    }
    _usedMemberIds.add(memberId);
    return memberId;
  }

  
  static void _removeMemberId(String memberId) {
    _usedMemberIds.remove(memberId);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'memberId': memberId,
        'borrowedBooks': borrowedBooks,
      };

  
  static Member fromJson(Map<String, dynamic> json) {
    final memberId = json['memberId'];
  
    if (_usedMemberIds.contains(memberId)) {
      throw ArgumentError('Member ID must be unique. The provided member ID is already used.');
    }

    
    final member = Member(
      name: json['name'],
      memberId: memberId,
      borrowedBooks: List<String>.from(json['borrowedBooks']),
    );

    
    _addMemberId(memberId);
    return member;
  }

  @override
  String toString() {
    return 'Name: $name, ID: $memberId, Borrowed Books: ${borrowedBooks.join(', ')}';
  }
}

void addMember(String name, String memberId, List<String> borrowedBooks) {
  try {
     final member = Member(
      name: name,
      memberId: memberId,
      borrowedBooks: borrowedBooks,
    );
    
  } catch (e) {
        print('Error: $e'); 
  }
}