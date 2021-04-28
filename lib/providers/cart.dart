import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

int cartItemId = 0; // Habad haboooood

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final List<String> imageUrls;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrls,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {
/*     'p111111': CartItem(
      id: 'p1',
      title: 'Adidas Shoes',
      quantity: 2,
      price: 12,
      imageUrls: [
        'https://freeiconshop.com/wp-content/uploads/edd/burger-flat.png',
      ],
    ) */
  };

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int count = 0;
    final values = _items.values.toList();
    for (int i = 0; i < _items.length; i++) {
      count += values[i].quantity;
    }
    return count;
  }

  double get total {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price;
    });
    return total;
  }

  int productQuantity(String id) {
    if (_items.containsKey(id)) return _items[id].quantity;
    return 0;
  }

  void addItem({
    @required String productId,
    @required double price,
    @required String title,
    @required int quantity,
    final List<String> imageUrls,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price + (price * quantity),
          quantity: existingCartItem.quantity + quantity,
          imageUrls: existingCartItem.imageUrls,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: cartItemId.toString(),
          title: title,
          price: price * quantity,
          quantity: quantity,
          imageUrls: imageUrls,
        ),
      );
      cartItemId++;
    }
    notifyListeners();
  }

  void deleteProductFromCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void undoAddingItem(String productId) {
    double picePrice = (_items[productId].price) / (_items[productId].quantity);
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1)
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price - picePrice,
          quantity: value.quantity - 1,
          imageUrls: value.imageUrls,
        ),
      );
    else
      deleteProductFromCart(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
