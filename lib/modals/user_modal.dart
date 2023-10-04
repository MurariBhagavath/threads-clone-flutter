class UserModal {
  final String uid;
  final String username;
  final String email;
  final String imageUrl;
  final List<String> followers;
  final List<String> following;

  UserModal({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.followers,
    required this.following,
  });

  factory UserModal.fromJson(Map<String, dynamic> json) => UserModal(
        uid: json['uid'],
        username: json['username'],
        email: json['email'],
        imageUrl: json['imageUrl'],
        followers: json['followers'],
        following: json['following'],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        'username': username,
        'email': email,
        'imageUrl': imageUrl,
        'followers': followers,
        'following': following
      };
}
