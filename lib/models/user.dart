class AppUser {
  String name;
  String email;
  

  AppUser({required this.name, required this.email, });

  toMap() {
    return {"name": name, "email": email, };
  }

  static fromMap(Map<String, dynamic> user) {
    return AppUser(name: user["name"], email: user["email"]);
  }
}