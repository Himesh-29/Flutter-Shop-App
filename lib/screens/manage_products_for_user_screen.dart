import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_by_user_screen.dart';

import '../widgets/user_product_item_to_be_displayed_on_manage_products_screen.dart';
import '../widgets/mainScreenDrawer.dart';

import '../providers/product_provider_blueprint.dart';

class ManageProductsForUserScreen extends StatelessWidget {
  static const routeName = '/Manage-products-for-user-Screen';

  Future<void> _onRefreshLoadProductsFromWebServer(BuildContext context) async {
    await Provider.of<ProductProviderBlueprint>(context, listen: false)
        .getAllTheProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final userProducts = Provider.of<ProductProviderBlueprint>(context);
    return Scaffold(
        drawer: MainScreenDrawer(),
        appBar: AppBar(
          title: const Text('GoShopping - Your Products'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductByUserScreen.routeName);
                }), //Helps us to navigate to a new page where user can add/edit/delete products
          ],
        ),
        body: FutureBuilder(
          future: _onRefreshLoadProductsFromWebServer(context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _onRefreshLoadProductsFromWebServer(context),
                  child: Consumer<ProductProviderBlueprint>(
                    builder: (ctx, userProducts, child) => Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: ListView.builder(
                          itemCount: userProducts.productItems.length,
                          itemBuilder: (ctxListView, index) => Column(
                            children: [
                              UserProductItemToBeDisplayedOnManageProductsScreen(
                                  userProducts.productItems[index]),
                              Divider(
                                  thickness: 5, color: Colors.lightBlue[100])
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
