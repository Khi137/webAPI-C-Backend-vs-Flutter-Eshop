class User {
  String? id;
  String? avatar;
  String? userName;
  String? fullname;
  String? email;
  String? phoneNumber;
  String? address;

  User({
    this.id,
    this.avatar,
    this.userName,
    this.fullname,
    this.email,
    this.address,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      userName:json['userName'],
      avatar: json['avatar'],
      email: json['email'],
      address: json['adress'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
