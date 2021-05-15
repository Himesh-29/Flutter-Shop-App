import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_blueprint.dart';

import '../screens/manage_products_for_user_screen.dart';
import '../screens/order_detail_screen.dart';

class MainScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Welcome to GoShopping'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop_rounded),
          title: Text('Discover new things in shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('My Orders'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(OrderDetailScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.precision_manufacturing_outlined),
          title: Text('Manage products on the screen'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ManageProductsForUserScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<AuthenticationBlueprint>(context, listen: false)
                .logout();
          },
        ),
      ],
    ));
  }
}
