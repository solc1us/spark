class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  final String id;
  final String name;
  final String email;
  // Dummy credentials for local simulation only.
  final String password;
}
