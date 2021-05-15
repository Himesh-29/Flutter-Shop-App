import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/MainScreenShowingProducts.dart';
import './screens/Product_Item_Details_Screen.dart';
import './screens/main_carts_screen.dart';
import './screens/order_detail_screen.dart';
import './screens/manage_products_for_user_screen.dart';
import './screens/edit_product_by_user_screen.dart';
import './screens/authentication_screen.dart';
import './screens/splash_screen.dart';

import 'providers/product_provider_blueprint.dart';
import 'providers/products_in_cart_blueprint.dart';
import 'providers/orders_blueprint.dart';
import 'providers/authentication_blueprint.dart';

import './helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthenticationBlueprint()),
        ChangeNotifierProvider(
          create: (context) => CartBlueprint(),
        ),
        ChangeNotifierProxyProvider<AuthenticationBlueprint,
            ProductProviderBlueprint>(
          create: (_) => ProductProviderBlueprint(null, null, []),
          update: (ctx, auth, previousProducts) => ProductProviderBlueprint(
            auth.token,
            auth.userID,
            previousProducts == null ? [] : previousProducts.productItems,
          ),
        ),
        ChangeNotifierProxyProvider<AuthenticationBlueprint, OrdersBlueprint>(
            create: (_) => OrdersBlueprint(null, null, []),
            update: (ctx, auth, previousOrders) => OrdersBlueprint(
                  auth.token,
                  auth.userID,
                  previousOrders == null ? [] : previousOrders.noOfOrders,
                )),
      ],
      child: Consumer<AuthenticationBlueprint>(
          builder: (ctx, authData, _) => MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.cyan,
                  accentColor: Colors.lightBlue[200],
                  backgroundColor: Color.fromRGBO(238, 255, 166, 1),
                  textTheme: ThemeData.light().textTheme.copyWith(
                        title: TextStyle(
                          fontFamily: 'Girassol',
                          color: Colors.white,
                        ),
                      ),
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: CustomPageTransitionBuilder(),
                      TargetPlatform.iOS: CustomPageTransitionBuilder(),
                    },
                  ),
                ),
                home: authData.isAutheticated
                    ? MainScreenShowingProducts(titleOfApp: 'GoShopping')
                    : FutureBuilder(
                        builder: (ctx, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? SplashScreen()
                                : AuthenticationScreen(),
                        future: authData.tryLogInAutomatically(),
                      ),
                routes: {
                  ProductItemDetailsScreen.routeName: (ctx) =>
                      ProductItemDetailsScreen(),
                  MainCartScreen.routeName: (ctx) => MainCartScreen(),
                  OrderDetailScreen.routeName: (ctx) => OrderDetailScreen(),
                  ManageProductsForUserScreen.routeName: (ctx) =>
                      ManageProductsForUserScreen(),
                  EditProductByUserScreen.routeName: (ctx) =>
                      EditProductByUserScreen(),
                },
              )),
    );
  }
}
