class Product {
  String? id;
  String? image;
  String? name;
  String? SKU;
  int? stock;
  int? price;
  String? producttypeid;
  int? status;
  Product({
    this.id,
    this.image,
    this.name,
    this.SKU,
    this.stock,
    this.price,
    this.producttypeid,
    this.status,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      SKU: json['SKU'],
      stock: json['stock'],
      price: json['price'],
      producttypeid: json['producttypeid'],
      status: json['status'],
    );
  }
}
