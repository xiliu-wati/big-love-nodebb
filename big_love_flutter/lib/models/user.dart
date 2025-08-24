class User {
  final int uid;
  final String username;
  final String email;
  final String? fullname;
  final String? picture;
  final String? aboutme;
  final int reputation;
  final int postcount;
  final DateTime joindate;
  final DateTime lastonline;
  final bool isAdmin;
  final bool isModerator;
  final List<String> groups;

  User({
    required this.uid,
    required this.username,
    required this.email,
    this.fullname,
    this.picture,
    this.aboutme,
    required this.reputation,
    required this.postcount,
    required this.joindate,
    required this.lastonline,
    required this.isAdmin,
    required this.isModerator,
    required this.groups,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullname: json['fullname'],
      picture: json['picture'],
      aboutme: json['aboutme'],
      reputation: json['reputation'] ?? 0,
      postcount: json['postcount'] ?? 0,
      joindate: DateTime.fromMillisecondsSinceEpoch(
        (json['joindate'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
      ),
      lastonline: DateTime.fromMillisecondsSinceEpoch(
        (json['lastonline'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
      ),
      isAdmin: json['administrator'] == 1 || json['isAdmin'] == true,
      isModerator: json['moderator'] == 1 || json['isModerator'] == true,
      groups: List<String>.from(json['groups'] ?? []),
    );
  }

  bool get isMvpUser => groups.contains('MVP Users');
  bool get isSpecialUser => groups.contains('Special Users');
  bool get isRegularUser => !isAdmin && !isModerator && !isMvpUser && !isSpecialUser;

  String get displayName => fullname?.isNotEmpty == true ? fullname! : username;

  String get avatarUrl {
    if (picture?.isNotEmpty == true) {
      if (picture!.startsWith('http')) {
        return picture!;
      } else {
        return 'https://biglove-nodebb.railway.app$picture';
      }
    }
    return 'https://ui-avatars.com/api/?name=${username[0].toUpperCase()}&background=6B46C1&color=fff&size=150';
  }

  User copyWith({
    int? uid,
    String? username,
    String? email,
    String? fullname,
    String? picture,
    String? aboutme,
    int? reputation,
    int? postcount,
    DateTime? joindate,
    DateTime? lastonline,
    bool? isAdmin,
    bool? isModerator,
    List<String>? groups,
  }) {
    return User(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      picture: picture ?? this.picture,
      aboutme: aboutme ?? this.aboutme,
      reputation: reputation ?? this.reputation,
      postcount: postcount ?? this.postcount,
      joindate: joindate ?? this.joindate,
      lastonline: lastonline ?? this.lastonline,
      isAdmin: isAdmin ?? this.isAdmin,
      isModerator: isModerator ?? this.isModerator,
      groups: groups ?? this.groups,
    );
  }
}
