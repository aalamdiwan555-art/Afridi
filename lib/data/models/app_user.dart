class AppUser {
  final String name;
  final String email;
  final String photoUrl;
  final bool isDemo;

  const AppUser({
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.isDemo = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        photoUrl: json['photoUrl'] ?? '',
        isDemo: json['isDemo'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'isDemo': isDemo,
      };

  String get initial => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}
