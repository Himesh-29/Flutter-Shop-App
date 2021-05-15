import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './products_in_cart_blueprint.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<ProductsInCartBlueprint> products;
  final DateTime dateAndTimeAtWhichOrderWasPlaced;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateAndTimeAtWhichOrderWasPlaced});
}

class OrdersBlueprint with ChangeNotifier {
  List<OrderItem> _noOfOrders = [];
  final String authToken;
  final String userID;

  OrdersBlueprint(this.authToken, this.userID, this._noOfOrders);

  //Getter for getting the number of orders
  List<OrderItem> get noOfOrders {
    return [..._noOfOrders];
  }

  //Getter for total amount of a particular order
  double totalAmountOfParticularOrder(index) {
    return _noOfOrders[index].amount;
  }

//Getter for number of products in a particular order
  List<ProductsInCartBlueprint> totalProductsInParticularOrder(index) {
    return _noOfOrders[index].products;
  }

//Getter for the date and time at which the particular order was placed
  DateTime dateAndTimeAtWhichParticularOrderWasPlaced(index) {
    return _noOfOrders[index].dateAndTimeAtWhichOrderWasPlaced;
  }

  Future<void> fetchAllOrders() async {
    final url = Uri.parse(
        'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/my-orders/$userID.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateAndTimeAtWhichOrderWasPlaced:
              DateTime.parse(orderData['dateAndTimeAtWhichOrderWasPlaced']),
          products: (orderData['products'] as List<dynamic>)
              .map((cartItems) => ProductsInCartBlueprint(
                  productIdInCart: cartItems['id'],
                  productNameInCart: cartItems['productNameInCart'],
                  productInCartQuantity: cartItems['productInCartQuantity'],
                  productPriceInCart: cartItems['productPriceInCart']))
              .toList()));
    });
    _noOfOrders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  //Adding an order
  Future<void> addOrder(
      List<ProductsInCartBlueprint> productsInCart, double total) async {
    final url = Uri.parse(
        'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/my-orders/$userID.json?auth=$authToken');
    final timeStampAtWhichOrderWasPlaced = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateAndTimeAtWhichOrderWasPlaced':
              timeStampAtWhichOrderWasPlaced.toIso8601String(),
          'products': productsInCart
              .map((cartProduct) => {
                    'productIdInCart': cartProduct.productIdInCart,
                    'productNameInCart': cartProduct.productNameInCart,
                    'productInCartQuantity': cartProduct.productInCartQuantity,
                    'productPriceInCart': cartProduct.productPriceInCart,
                  })
              .toList(),
        }));
    _noOfOrders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateAndTimeAtWhichOrderWasPlaced: timeStampAtWhichOrderWasPlaced,
          products: productsInCart,
        ));
    notifyListeners();
  }
}
