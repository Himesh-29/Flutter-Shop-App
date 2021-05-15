import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/orders_blueprint.dart';

import '../widgets/mainScreenDrawer.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '\my-orders-screen';

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  var _isPageLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isPageLoading = true;
      });
      await Provider.of<OrdersBlueprint>(context, listen: false)
          .fetchAllOrders();
      setState(() {
        _isPageLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderDetails = Provider.of<OrdersBlueprint>(context);
    if (orderDetails.noOfOrders.length != 0) {
      return Scaffold(
        appBar: AppBar(title: Text('GoShopping - Your Orders')),
        drawer: MainScreenDrawer(),
        body: _isPageLoading
            ? CircularProgressIndicator()
            : Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: orderDetails.noOfOrders.length,
                  itemBuilder: (ctx, index) => Column(children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: FittedBox(
                              child: Text(
                                orderDetails
                                    .totalAmountOfParticularOrder(index)
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      trailing: Text(
                          DateFormat('dd-MM-yyyy||hh:mm||')
                              .format(orderDetails
                                  .dateAndTimeAtWhichParticularOrderWasPlaced(
                                      index))
                              .toString(),
                          style: TextStyle(fontSize: 20)),
                      title: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 3)),
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ListView.builder(
                            itemCount: orderDetails
                                .totalProductsInParticularOrder(index)
                                .length,
                            itemBuilder: (context, indexForNoOfProducts) => Text(
                                '• ${orderDetails.totalProductsInParticularOrder(index)[indexForNoOfProducts].productNameInCart}')),
                      ),
                    ),
                    Divider(
                      thickness: 20,
                    )
                  ]),
                ),
              ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('GoShopping - Your Orders')),
        drawer: MainScreenDrawer(),
        body: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Text(
              'Your order list is empty. Try placing some orders',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
      );
    }
  }
}
