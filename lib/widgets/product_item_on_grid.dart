import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_blueprint.dart';
import '../providers/products_in_cart_blueprint.dart';

import '../screens/Product_Item_Details_Screen.dart';
import '../providers/product_blueprint.dart';

// ignore: must_be_immutable
class ProductItemOnGrid extends StatelessWidget {
  ProductBlueprint item;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    ProductBlueprint item =
        Provider.of<ProductBlueprint>(context, listen: false);
    CartBlueprint cart = Provider.of<CartBlueprint>(context, listen: false);
    final authData =
        Provider.of<AuthenticationBlueprint>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
            onTap: () => {
                  Navigator.of(context).pushNamed(
                      ProductItemDetailsScreen.routeName,
                      arguments: item)
                },
            child: Hero(
              tag: item.productId,
              child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(
                    item.productImageURL,
                  )),
            )),
        footer: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: GridTileBar(
              backgroundColor: Color.fromRGBO(10, 10, 14, 0.7),
              leading: IconButton(
                iconSize: 30,
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  cart.addItemInCart(
                      item.productId, item.productName, item.productPrice);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Added the item to cart!'),
                    duration: Duration(seconds: 4),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItemFromCart(item.productId);
                      },
                    ),
                  ));
                },
              ),
              title: Text(
                item.productName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
              trailing: Consumer<ProductBlueprint>(
                builder: (ctx, item, child) => IconButton(
                    iconSize: 30,
                    icon: item.isFavourite
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () async {
                      try {
                        await item.toggleFavouriteOnProduct(
                            authData.token, authData.userID);
                      } catch (error) {
                        scaffold.showSnackBar(SnackBar(
                            backgroundColor: Colors.black54,
                            content: SnackBarAction(
                                label:
                                    'Couldn\'t change the favourite status. Some issue occured!',
                                textColor: Colors.white,
                                onPressed: () {})));
                      }
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
