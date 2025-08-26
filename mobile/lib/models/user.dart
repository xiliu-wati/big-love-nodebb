class User {
  final int id;
  final String username;
  final String email;
  final String? fullname;
  final String? picture;
  final String? aboutme;
  final String role;
  final DateTime joinedAt;
  final DateTime? lastOnline;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.fullname,
    this.picture,
    this.aboutme,
    required this.role,
    required this.joinedAt,
    this.lastOnline,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullname: json['fullname'],
      picture: json['picture'],
      aboutme: json['aboutme'],
      role: json['role'] ?? 'user',
      joinedAt: json['joinedAt'] != null 
        ? DateTime.parse(json['joinedAt'])
        : DateTime.now(),
      lastOnline: json['lastOnline'] != null 
        ? DateTime.parse(json['lastOnline'])
        : null,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator';
  bool get isMvpUser => role == 'mvp';
  bool get isSpecialUser => role == 'special';
  bool get isRegularUser => role == 'user';

  String get displayName => fullname?.isNotEmpty == true ? fullname! : username;

  String get avatarUrl {
    if (picture?.isNotEmpty == true) {
      if (picture!.startsWith('http')) {
        return picture!;
      } else {
        return 'https://kind-vibrancy-production.up.railway.app$picture';
      }
    }
    return 'https://ui-avatars.com/api/?name=${username[0].toUpperCase()}&background=6B46C1&color=fff&size=150';
  }

  // Compatibility properties for profile screen
  int get postcount => 0; // Mock data for now
  int get reputation => 0; // Mock data for now
  DateTime get joindate => joinedAt; // Use joinedAt as joindate
  List<String> get groups => []; // Empty groups for now

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? fullname,
    String? picture,
    String? aboutme,
    String? role,
    DateTime? joinedAt,
    DateTime? lastOnline,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      picture: picture ?? this.picture,
      aboutme: aboutme ?? this.aboutme,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      lastOnline: lastOnline ?? this.lastOnline,
    );
  }
}
