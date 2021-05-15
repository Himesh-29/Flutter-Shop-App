import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/httpExceptionClass.dart';

import './product_blueprint.dart';

class ProductProviderBlueprint with ChangeNotifier {
  final String authToken;
  final String userID;
  List<ProductBlueprint> _productItems = [];
  ProductProviderBlueprint(this.authToken, this.userID, this._productItems);

  //Getter for product items
  List<ProductBlueprint> get productItems {
    return [..._productItems];
  }

  List<ProductBlueprint> get favouriteProductItems {
    return [..._productItems.where((element) => element.isFavourite == true)];
  }

  String get products => null;

  //Finding a product item using the ID provided
  ProductBlueprint findProductById(String providedID) {
    return _productItems
        .firstWhere((productItem) => productItem.productId == providedID);
  }

  //Finding all the products from the server
  Future<void> getAllTheProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorID"&equalTo="$userID"' : '';
    final url = Uri.parse(
        'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/products-on-main-screen.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductBlueprint> loadedProducts = [];
      if (extractedData == null) return;
      final favouriteResponse = await http.get(Uri.parse(
          'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/userFavourites/$userID.json?auth=$authToken'));
      final favouriteData = json.decode(favouriteResponse.body);
      extractedData.forEach((productIDGot, productDataInFormOfMap) {
        loadedProducts.add(ProductBlueprint(
          productId: productIDGot,
          productName: productDataInFormOfMap['productName'],
          productPrice: productDataInFormOfMap['productPrice'],
          productImageURL: productDataInFormOfMap['productImageURL'],
          productDescription: productDataInFormOfMap['productDescription'],
          isFavourite: favouriteData == null
              ? false
              : favouriteData[productIDGot] ?? false,
        ));
      });
      _productItems = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  //Adding a product item to our list of product items
  Future<void> addProductItem(ProductBlueprint item) async {
    final url = Uri.parse(
        'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/products-on-main-screen.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'productName': item.productName,
            'productDescription': item.productDescription,
            'productPrice': item.productPrice,
            'productImageURL': item.productImageURL,
            'creatorID': userID,
          }));
      final newProductItem = ProductBlueprint(
        productId: json.decode(response.body)['name'],
        productImageURL: item.productImageURL,
        productName: item.productName,
        productDescription: item.productDescription,
        productPrice: item.productPrice,
      );
      _productItems.add(newProductItem);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  //Updating an existing product
  Future<void> updateExistingProduct(
      String productIdToBeUpdated, ProductBlueprint newProduct) async {
    final productIndex = _productItems
        .indexWhere((element) => element.productId == productIdToBeUpdated);
    if (productIndex >= 0) {
      try {
        final newUrl = Uri.parse(
            'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/products-on-main-screen/$productIdToBeUpdated.json?auth=$authToken');
        http.patch(newUrl,
            body: json.encode({
              'productName': newProduct.productName,
              'productDescription': newProduct.productDescription,
              'productPrice': newProduct.productPrice,
              'productImageURL': newProduct.productImageURL,
              'isFavourite': newProduct.isFavourite,
            }));
        _productItems[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  //Deleting a product
  Future<void> deleteProduct(String productIdToBeDeleted) async {
    final productToBeDeleted = _productItems[_productItems
        .indexWhere((element) => element.productId == productIdToBeDeleted)];
    try {
      final newUrl = Uri.parse(
          'https://myfluttershopapp-e5365-default-rtdb.firebaseio.com/products-on-main-screen/$productIdToBeDeleted.json?auth=$authToken');
      _productItems
          .removeWhere((element) => element.productId == productIdToBeDeleted);
      final response = await http.delete(newUrl);
      if (response.statusCode >= 400) {
        throw HTTPExceptionClass(
            'Couldn\'t delete the product, some issue occured!');
      }
      notifyListeners();
    } catch (error) {
      _productItems.insert(
          _productItems.indexWhere(
              (element) => element.productId == productIdToBeDeleted),
          productToBeDeleted);
      error.toString();
    }
  }
}
