class Invoice {
  int? id;
  String? Code;
  String? userId;
  String? productId;
  String? productName;
  String? ShippingAddress;
  String? ShippingPhone;
  int? Total;
  Invoice({
    this.id,
    this.userId,
    this.productId,
    this.productName,
    this.ShippingAddress,
    this.ShippingPhone,
    this.Total,
  });
}
