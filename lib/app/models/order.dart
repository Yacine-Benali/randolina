class Order {
  Order({
    required this.quantity,
    required this.color,
    required this.size,
    required this.comment,
  });

  final int quantity;
  final String color;
  final String size;
  final String comment;

  factory Order.fromMap(Map<String, dynamic> data) {
    final int quantity = data['quantity'] as int;
    final String color = data['color'] as String;
    final String size = data['size'] as String;
    final String comment = data['comment'] as String;

    return Order(
      quantity: quantity,
      color: color,
      size: size,
      comment: comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'color': color,
      'size': size,
      'comment': comment,
    };
  }
}
