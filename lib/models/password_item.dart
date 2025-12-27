class PasswordItem {
  final int? id;
  final String title;
  final String username;
  final String password;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PasswordItem({
    this.id,
    required this.title,
    required this.username,
    required this.password,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Create instance from map
  factory PasswordItem.fromMap(Map<String, dynamic> map) {
    return PasswordItem(
      id: map['id'] as int?,
      title: map['title'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  /// Create a copy with modified fields
  PasswordItem copyWith({
    int? id,
    String? title,
    String? username,
    String? password,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PasswordItem(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
