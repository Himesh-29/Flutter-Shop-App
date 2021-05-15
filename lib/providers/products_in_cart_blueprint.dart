import 'package:flutter/widgets.dart';

class ProductsInCartBlueprint {
  final String productIdInCart;
  final String productNameInCart;
  final int productInCartQuantity;
  final double productPriceInCart;

  ProductsInCartBlueprint(
      {@required this.productIdInCart,
      @required this.productNameInCart,
      @required this.productInCartQuantity,
      @required this.productPriceInCart});
}

class CartBlueprint with ChangeNotifier {
  Map<String, ProductsInCartBlueprint> _itemsInCart = {};

  //getter for items in cart
  Map<String, ProductsInCartBlueprint> get itemsInCart {
    return {..._itemsInCart};
  }

  //getter for number of items in a cart
  int get numberOfItemsInCart {
    return _itemsInCart.length;
  }

  //getter for total amount
  double get totalAmountForItemsInCart {
    var total = 0.0;
    _itemsInCart.forEach((key, value) {
      total += value.productPriceInCart * value.productInCartQuantity;
    });
    return total;
  }

  void addItemInCart(String idOfItemToBeAdded, String nameOfItemToBeAdded,
      double priceOfItemToBeAdded) {
    if (_itemsInCart.containsKey(idOfItemToBeAdded)) {
      //Change the existing details of the particular Product in the cart
      _itemsInCart.update(
          idOfItemToBeAdded,
          (existingCartItem) => ProductsInCartBlueprint(
              productIdInCart: existingCartItem.productIdInCart,
              productNameInCart: existingCartItem.productNameInCart,
              productInCartQuantity: existingCartItem.productInCartQuantity + 1,
              productPriceInCart: existingCartItem.productPriceInCart));
    } else {
      //We have to add a new entry in the cart
      _itemsInCart.putIfAbsent(
          idOfItemToBeAdded,
          () => ProductsInCartBlueprint(
              productIdInCart: DateTime.now().toString(),
              productNameInCart: nameOfItemToBeAdded,
              productInCartQuantity: 1,
              productPriceInCart: priceOfItemToBeAdded));
    }
    notifyListeners();
  }

  void removeItemFromCart(String idReceived) {
    _itemsInCart.remove(idReceived);
    notifyListeners();
  }

  //Clearing all the contents present in the cart
  void clearCart() {
    _itemsInCart.clear();
    notifyListeners();
  }

  //To remove an item from cart
  //Will remove the item if it is present, and then we check that if there are multiple quantities of the same item, then
  //we will decrease the quantity by one, else if quantity is 1, then we will completely remove the item from the cart.
  void removeSingleItemFromCart(String idReceived) {
    if (_itemsInCart.containsKey(idReceived)) {
      if (_itemsInCart[idReceived].productInCartQuantity > 1) {
        _itemsInCart.update(
            idReceived,
            (existingCartItem) => ProductsInCartBlueprint(
                productIdInCart: existingCartItem.productIdInCart,
                productNameInCart: existingCartItem.productNameInCart,
                productInCartQuantity:
                    existingCartItem.productInCartQuantity - 1,
                productPriceInCart: existingCartItem.productPriceInCart));
      } else {
        _itemsInCart.remove(idReceived);
      }
    } else {
      return;
    }
    notifyListeners();
  }
}
