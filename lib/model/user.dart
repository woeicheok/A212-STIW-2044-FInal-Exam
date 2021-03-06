class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;
  String? dateReg;
  String? cart;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.address,
      this.dateReg,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    address = json['address'];
    dateReg = json['dateReg'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['address'] = address;
    data['dateReg'] = dateReg;
    data['cart'] = cart.toString();
    return data;
  }
}
