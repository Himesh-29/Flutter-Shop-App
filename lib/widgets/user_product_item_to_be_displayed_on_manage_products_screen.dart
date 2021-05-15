import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_blueprint.dart';
import '../providers/product_provider_blueprint.dart';

import '../screens/edit_product_by_user_screen.dart';

class UserProductItemToBeDisplayedOnManageProductsScreen
    extends StatelessWidget {
  final ProductBlueprint userProductSingleItem;

  UserProductItemToBeDisplayedOnManageProductsScreen(
      this.userProductSingleItem);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(userProductSingleItem.productName),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userProductSingleItem.productImageURL),
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(children: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                    EditProductByUserScreen.routeName,
                    arguments: userProductSingleItem.productId);
              },
              color: Colors.green),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<ProductProviderBlueprint>(context,
                          listen: false)
                      .deleteProduct(userProductSingleItem.productId);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                      backgroundColor: Colors.black54,
                      content: SnackBarAction(
                          label:
                              'Couldn\'t delete the product. Some Issue occured!',
                          textColor: Colors.white,
                          onPressed: () {})));
                }
              },
              color: Colors.red),
        ]),
      ),
    );
  }
}
