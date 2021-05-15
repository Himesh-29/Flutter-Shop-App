import 'package:flutter/material.dart';

import '../providers/product_blueprint.dart';

class ProductItemDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';

  @override
  Widget build(BuildContext context) {
    ProductBlueprint productItem = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(title: Text(productItem.productName)),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.lightGreen[100],
            child: Column(children: [
              SizedBox(height: 30),
              Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                    child: Text('${productItem.productName}',
                        style: TextStyle(fontSize: 25)),
                  )),
              SizedBox(height: 30),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3)),
                  child: Hero(
                    tag: productItem.productId,
                    child: Image.network(
                      productItem.productImageURL,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Product Description',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      Text(productItem.productDescription.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          )),
                    ],
                  )),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Text('${productItem.productPrice}',
                      style: TextStyle(
                        backgroundColor: Colors.purple[100],
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ]),
          ),
        ));
  }
}
