import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_in_cart_blueprint.dart';
import '../widgets/cart_items_to_be_displayed_on_carts_main_screen.dart';

import '../providers/orders_blueprint.dart';

class MainCartScreen extends StatefulWidget {
  static const routeName = '\main-cart-screen';

  @override
  _MainCartScreenState createState() => _MainCartScreenState();
}

class _MainCartScreenState extends State<MainCartScreen> {
  @override
  Widget build(BuildContext context) {
    CartBlueprint cartDataForScreen = Provider.of<CartBlueprint>(context);
    return Scaffold(
      appBar: AppBar(title: Text('GoShopping - Your cart')),
      body: Column(
        children: <Widget>[
          Card(
              color: Colors.lime[200],
              elevation: 20,
              margin: EdgeInsets.all(10),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 23),
                        ),
                        Chip(
                          backgroundColor: Colors.purple,
                          label: Text(
                            'Rs. ${cartDataForScreen.totalAmountForItemsInCart.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  ]))),
          SizedBox(height: 20),
          Container(
              // margin: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black45)),
              child: ListView.builder(
                  itemCount: cartDataForScreen.numberOfItemsInCart,
                  itemBuilder: (ctx, index) => CartItemOnCartScreen(
                        cartDataForScreen.itemsInCart.values.toList()[index],
                        cartDataForScreen.itemsInCart.keys.toList()[index],
                      ))),
          Container(
            margin: EdgeInsets.only(top: 20),
            color: Colors.lightBlue[100],
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: PlaceOrderButton(cartDataForScreen: cartDataForScreen),
          ),
        ],
      ),
    );
  }
}

class PlaceOrderButton extends StatefulWidget {
  const PlaceOrderButton({
    Key key,
    @required this.cartDataForScreen,
  }) : super(key: key);

  final CartBlueprint cartDataForScreen;

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  var _isButtonLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: (widget.cartDataForScreen.totalAmountForItemsInCart == 0 ||
                _isButtonLoading)
            ? null
            : () async {
                setState(() {
                  _isButtonLoading = true;
                });
                await Provider.of<OrdersBlueprint>(context, listen: false)
                    .addOrder(
                        widget.cartDataForScreen.itemsInCart.values.toList(),
                        widget.cartDataForScreen.totalAmountForItemsInCart);
                setState(() {
                  _isButtonLoading = false;
                });
                widget.cartDataForScreen.clearCart();
              },
        child: _isButtonLoading
            ? CircularProgressIndicator()
            : Text('Place Order', style: TextStyle(fontSize: 22)));
  }
}
