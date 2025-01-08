class Admin {
  int? adminID;
  String? password;
  String? name;
  String? email;
  String? phoneNumber;
  String? token; 

  Admin({
    this.adminID,
    this.password,
    this.name,
    this.email,
    this.phoneNumber,
    this.token, 
  });

  Admin.fromJson(Map<String, dynamic> json) {
    adminID = json['adminid'];
    password = json['password'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phonenumber'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'adminid': adminID,
      'password': password,
      'name': name,
      'email': email,
      'phonenumber': phoneNumber,
      'token': token,
    };
  }
  
}
