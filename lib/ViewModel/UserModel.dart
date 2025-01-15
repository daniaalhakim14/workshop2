class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? personalImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.personalImage
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('[DEBUG] Parsing UserModel from JSON: $json');
    return UserModel(
      id: json['id'] ?? json['userid'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      phone: json['phonenumber'] ?? '',
      address: json['address'] ?? '',
      personalImage: json['personalimage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': id,
      'name': name,
      'email': email,
      'phonenumber': phone,
      'address': address,
      'personalimage': personalImage,
    };
  }
}
