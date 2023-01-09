class Cart {
  int? id;
  String? userId;
  String? productId;
  String? productName;
  int? quantity;
  String? image;
  int? price;
  Cart({
    this.id,
    this.userId,
    this.productId,
    this.productName,
    this.quantity,
    this.image,
    this.price,
  });
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }
}
