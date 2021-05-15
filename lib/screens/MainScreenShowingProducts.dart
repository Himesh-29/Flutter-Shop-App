import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/main_carts_screen.dart';

import '../widgets/mainScreenDrawer.dart';

import '../providers/products_in_cart_blueprint.dart';
import '../providers/product_blueprint.dart';
import '../providers/product_provider_blueprint.dart';

import '../widgets/Products_Grid_on_main_screen.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  ShowAll,
}

class MainScreenShowingProducts extends StatefulWidget {
  final titleOfApp;
  MainScreenShowingProducts({this.titleOfApp});

  @override
  _MainScreenShowingProductsState createState() =>
      _MainScreenShowingProductsState();
}

class _MainScreenShowingProductsState extends State<MainScreenShowingProducts> {
  var _showFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
       setState(() {
        _isLoading = true;
      });
 Provider.of<ProductProviderBlueprint>(context).getAllTheProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //CartBlueprint cart = Provider.of<CartBlueprint>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.titleOfApp),
        actions: <Widget>[
          Consumer<CartBlueprint>(
            builder: (ctx, cartItems, childIconButton) => Badge(
              child: childIconButton,
              value: cartItems.numberOfItemsInCart.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.of(context).pushNamed(MainCartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) => {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavourites = true;
                } else if (selectedValue == FilterOptions.ShowAll) {
                  _showFavourites = false;
                }
              }),
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.ShowAll,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: MainScreenDrawer(),
      body: _isLoading
          ? Container(
              alignment: Alignment.center, child: CircularProgressIndicator())
          : ProductsGridOnMainScreen(_showFavourites),
    );
  }
}
