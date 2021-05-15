import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_in_cart_blueprint.dart';

class CartItemOnCartScreen extends StatelessWidget {
  final ProductsInCartBlueprint singleCartDataForScreen;
  final productIdToBeRemoved;

  CartItemOnCartScreen(this.singleCartDataForScreen, this.productIdToBeRemoved);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (directionDismissed) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove that item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    )
                  ],
                ));
      },
      key: ValueKey(singleCartDataForScreen.productIdInCart),
      onDismissed: (direction) {
        Provider.of<CartBlueprint>(context, listen: false)
            .removeItemFromCart(productIdToBeRemoved);
      },
      background: Container(
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          )),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: EdgeInsets.all(7),
              child: FittedBox(
                child: Text(
                  'Rs. ${singleCartDataForScreen.productPriceInCart}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          title: Text(
            '${singleCartDataForScreen.productNameInCart}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Total: Rs.${singleCartDataForScreen.productPriceInCart * singleCartDataForScreen.productInCartQuantity}',
          ),
          trailing: Text(
            '${singleCartDataForScreen.productInCartQuantity}x',
          ),
        ),
      ),
    );
  }
}
