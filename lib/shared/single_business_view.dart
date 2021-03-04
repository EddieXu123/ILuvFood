import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/business_item.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/screens/home/customer/checkout.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/errorPage.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class SingleBusinessView extends StatefulWidget {
  final Business business;
  SingleBusinessView({this.business});

  @override
  _SingleBusinessViewState createState() => _SingleBusinessViewState();
}

class _SingleBusinessViewState extends State<SingleBusinessView> {
  @override
  Widget build(BuildContext context) {
    CartModel cart = context.watch<CartModel>();
    cart.businessUid = widget.business.uid;
    return StreamProvider<List<BusinessItem>>.value(
      value: DatabaseService().getBusinessItem(widget.business.uid),
      child: WillPopScope(
        onWillPop: () {
          cart.reset();
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "${widget.business.businessName ?? "<no name found>"}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
              ),
              elevation: 0.0,
            ),
            body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                children: [
                  SizedBox(height: 20.0),
                  Text(widget.business.address),
                  SizedBox(height: 10.0),
                  Text(widget.business.phone),
                  SizedBox(height: 10.0),
                  Text("<${widget.business.lat}, ${widget.business.lng}>"),
                  // insert scroll view
                  SizedBox(height: 25.0),
                  SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: ItemScrollView(businessId: widget.business.uid),
                    // child: snapshot.hasData
                    //     ? ItemScrollView(
                    //         businessItems: snapshot.data,
                    //         businessId: widget.business.uid)
                    //     : Loading(),
                  ),
                  // FutureBuilder<int>(
                  //     future: cart.priceInCart,
                  //     builder: (BuildContext context,
                  //         AsyncSnapshot<int> snapshot) {
                  //       return snapshot.hasData
                  //           ? Text("Cart Price: \$${snapshot.data}")
                  //           : Loading();
                  //     }),
                  SizedBox(
                    child: Text("Cart Price: \$${cart.priceInCart}"),
                  ),
                  SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Checkout()));
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (BuildContext context) {
                      //     var test = context.watch<CartModel>();
                      //     return ChangeNotifierProvider(
                      //         create: (context) => test, child: Checkout());
                      //   }),
                      // );
                    },
                    child: Text(
                      'Checkout',
                      style: linkedPageTextStyle,
                    ),
                  )
                ],
              )
            ])),
      ),
    );
  }
}

class ItemScrollView extends StatefulWidget {
  // todo: refactor so business is in a streamprovider
  final String businessId;
  ItemScrollView({this.businessId});
  @override
  _ItemScrollViewState createState() => _ItemScrollViewState();
}

class _ItemScrollViewState extends State<ItemScrollView> {
  @override
  Widget build(BuildContext context) {
    final itemList = Provider.of<List<BusinessItem>>(context);
    return itemList == null
        ? Loading()
        : Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return _MyListItem(widget.businessId, index);
                }, childCount: itemList.length)),
              ],
            ),
          );
  }
}

class _MyListItem extends StatelessWidget {
  final _databaseService = DatabaseService();

  final int index;
  final String businessId;

  _MyListItem(this.businessId, this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemList = Provider.of<List<BusinessItem>>(context) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: LimitedBox(
        maxHeight: 48,
        child: Container(
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: (() async {
              print("attempting to add to cart");
              try {
                var cart = context.read<CartModel>();
                cart.add(itemList[index].uid);
                final val = await _databaseService.readBusinessItem(
                    businessId, itemList[index].uid);
                print("added? ${val.item}");
              } catch (e) {
                print("something went wrong: $e");
              }
            }),
            child: Center(
                child: Column(
              children: [
                Text(
                  "Entree: ${itemList[index].item}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
                Text(
                  "Price: \$${itemList[index].price}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
                Text(
                  "Qty: ${itemList[index].quantity}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
              ],
            )
                // child: Text(
                //   businessItems[index].item,

                // ),
                ),
          ),
        ),
      ),
    );
  }
}
