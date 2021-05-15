import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item_on_grid.dart';
import '../providers/product_provider_blueprint.dart';

class ProductsGridOnMainScreen extends StatelessWidget {
  @override
  final bool showFavourite;
  ProductsGridOnMainScreen(this.showFavourite);
  Widget build(BuildContext context) {
    final listOfProductsOnMainScreen = showFavourite
        ? Provider.of<ProductProviderBlueprint>(context).favouriteProductItems
        : Provider.of<ProductProviderBlueprint>(context).productItems;

    if (listOfProductsOnMainScreen.length == 0)
      return Container(
        alignment: Alignment.center,
        child: Text(
          'You currently have no items as Favourite. Try adding some',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        height: MediaQuery.of(context).size.height,
      );
    else
      return GridView.builder(
        itemCount: listOfProductsOnMainScreen.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5 / 6, //Meaning for 500 width, we want 600 height
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: listOfProductsOnMainScreen[index],
            child: ProductItemOnGrid()),
      );
  }
}
