import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/httpExceptionClass.dart';

class ProductBlueprint with ChangeNotifier {
  final String productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productImageURL;
  bool isFavourite;

  ProductBlueprint(
      {@required this.productId,
      @required this.productName,
      this.productDescription,
      @required this.productPrice,
      @required this.productImageURL,
      this.isFavourite = false});

  Future<void> toggleFavouriteOnProduct(String token, String userID) async {
    final oldChoice = isFavourite;
    final url = Uri.parse(
        'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/userFavourites/$userID/$productId.json?auth=$token');
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        throw HTTPExceptionClass('');
      }
      notifyListeners();
    } catch (error) {
      isFavourite = oldChoice;
      notifyListeners();
      throw error;
    }
  }
}
