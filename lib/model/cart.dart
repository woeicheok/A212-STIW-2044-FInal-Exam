class Cart {
  String? cartid;
  String? subjectname;
  String? price;
  String? cartqty;
  String? subjectsessions;
  String? subjectId;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.subjectname,
      this.price,
      this.cartqty,
      this.subjectsessions,
      this.subjectId,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cart_id'];
    subjectname = json['subject_name'];
    price = json['price'];
    cartqty = json['cart_qty'];
    subjectsessions = json['subject_sessions'];
    subjectId = json['subject_Id'];
    pricetotal = json['price_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartid;
    data['subject_name'] = subjectname;
    data['price'] = price;
    data['cart_qty'] = cartqty;
    data['subject_sessions'] = subjectsessions;
    data['subject_Id'] = subjectId;
    data['price_total'] = pricetotal;
    return data;
  }
}
