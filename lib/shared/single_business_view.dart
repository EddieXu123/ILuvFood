import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/models/business_item.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/screens/home/customer/checkout.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:toast/toast.dart';

///
/// Displays a specific business's information and all items they have currently listed
class SingleBusinessView extends StatefulWidget {
  final Business business;
  final Customer customer;
  SingleBusinessView({this.business, this.customer});

  @override
  _SingleBusinessViewState createState() => _SingleBusinessViewState();
}

class _SingleBusinessViewState extends State<SingleBusinessView> {
  @override
  Widget build(BuildContext context) {
    CartModel cart = context.watch<CartModel>();
    cart.businessUid = widget.business.uid;
    cart.businessName = widget.business.businessName;
    return StreamProvider<List<BusinessItem>>.value(
      value: DatabaseService().getBusinessItem(widget.business.uid),
      child: StreamBuilder<Business>(
          stream:
              DatabaseService().singleBusinessDataStream(widget.business.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Business businessData = snapshot.data;
              return WillPopScope(
                onWillPop: () {
                  cart.reset();
                  return Future.value(true);
                },
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.store)),
                          Tab(icon: Icon(Icons.list)),
                        ],
                      ),
                      title: Text(
                        "${businessData.businessName ?? "<no name found>"}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      elevation: 0.0,
                    ),
                    body: TabBarView(children: [
                      InfoTab(
                        business: businessData,
                        customer: widget.customer,
                      ),
                      MenuTab(
                        business: businessData,
                        cart: cart,
                      ),
                    ]),
                  ),
                ),
              );
            } else {
              return Loading();
            }
          }),
    );
  }
}

class InfoTab extends StatefulWidget {
  // todo: refactor so business is in a streamprovider
  final Business business;
  final Customer customer;
  InfoTab({this.business, this.customer});
  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(children: [
          SizedBox(height: 20.0),
          SizedBox(
            width: 350.0,
            height: 300.0,
            child: Image.network(
              widget.business.image,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 20.0),
          Text(widget.business.address),
          SizedBox(height: 10.0),
          Text(widget.business.phone),
          SizedBox(height: 150.0),
          FavoriteButton(
            isFavorite: widget.customer.favorites.contains(widget.business.uid),
            valueChanged: (_isFavorite) {
              print('Is Favorite : $_isFavorite');
              _databaseService.customerUpdateFavorites(
                  widget.customer.uid, widget.business.uid, _isFavorite);
            },
          ),
        ]),
      ]),
    );
  }
}

class MenuTab extends StatefulWidget {
  // todo: refactor so business is in a streamprovider
  final Business business;
  final CartModel cart;
  MenuTab({this.business, this.cart});
  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: [
            // insert scroll view
            SizedBox(height: 25.0),
            SizedBox(
              width: 300.0,
              height: 500.0,
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
            // SizedBox(
            //   child: Text(
            //       "Cart Price: \$${widget.cart.priceInCart.toStringAsFixed(2)}"),
            // ),
            SizedBox(height: 10.0),
            InkWell(
              onTap: () {
                if (widget.cart.cartItems.length == 0) {
                  Toast.show("Your Cart is Empty!", context,
                      duration: 2, gravity: Toast.CENTER);
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Checkout()));
                }
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
                style: TextStyle(
                    color: Colors.pink,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 23.0),
              ),
            ),
          ],
        ),
      ]),
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

  List<BusinessItem> itemList;
  final myController = TextEditingController();

  Widget _decrementButton(BuildContext context, int index) {
    return Container(
        width: 30.0,
        height: 30.0,
        child: FittedBox(
            child: FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.remove, color: Colors.black87),
                backgroundColor: Colors.white,
                onPressed: () async {
                  print("attempting to remove from cart");
                  try {
                    var cart = context.read<CartModel>();
                    cart.remove(itemList[index].uid);
                    final val = await _databaseService.readBusinessItem(
                        businessId, itemList[index].uid);
                    print("removed? ${val.item}");
                  } catch (e) {
                    print("something went wrong: $e");
                  }
                })));
  }

  Widget _incrementButton(BuildContext context, int index) {
    int totalQuantity = (itemList[index].quantity == null)
        ? 0
        : int.parse(itemList[index].quantity);

    return Container(
        width: 30.0,
        height: 30.0,
        child: FittedBox(
            child: FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.add, color: Colors.black87),
                backgroundColor: Colors.white,
                onPressed: () async {
                  print("attempting to add to cart");
                  try {
                    var cart = context.read<CartModel>();
                    if (totalQuantity <= int.parse(myController.text)) {
                      //max quantity reached
                      final snackBar = SnackBar(
                          content: Text(
                              'There are only ${totalQuantity} of that item available.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      cart.add(itemList[index].uid);
                      final val = await _databaseService.readBusinessItem(
                          businessId, itemList[index].uid);
                      print("added? ${val.item}");
                    }
                  } catch (e) {
                    print("something went wrong: $e");
                  }
                })));
  }

  void _setQuantity(
      BuildContext context, int index, int currentQuantity) async {
    print("attempting to set the quantity of an item in cart");

    int totalQuantity = int.parse(itemList[index].quantity);
    int newQuantity = int.parse(myController.text);
    try {
      var cart = context.read<CartModel>();
      while (currentQuantity != newQuantity) {
        if (currentQuantity > newQuantity) {
          cart.remove(itemList[index].uid);
          currentQuantity--;
        } else {
          if (totalQuantity == currentQuantity) {
            print("max quantity reached");
            myController.text = totalQuantity.toString();
            final snackBar = SnackBar(
                content: Text(
                    'There are only ${totalQuantity} of that item available.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            break;
          }
          cart.add(itemList[index].uid);
          currentQuantity++;
        }
      }
      final val = await _databaseService.readBusinessItem(
          businessId, itemList[index].uid);
      print("updated? ${val.item}");
    } catch (e) {
      print("something went wrong: $e");
    }
  }

  Future<int> getQuantity(BuildContext context, int index) {
    var cart = context.read<CartModel>();
    return cart.getQuantity(itemList[index].uid);
    //const quantity = itemList[index].quantity;
    //return (quantity == null) ? 999 : quantity;
  }

  @override
  Widget build(BuildContext context) {
    itemList = Provider.of<List<BusinessItem>>(context) ?? [];
    myController
        .addListener(() => {print("New Quantity: ${myController.text}")});

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: 150.0,
              child: Text(
                //"Entree: ${itemList[index].item} \nPrice: \$${itemList[index].price}",
                "${itemList[index].item}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
              ),
            ),
            _decrementButton(context, index),
            SizedBox(
                width: 50.0,
                child: FutureBuilder(
                    future: getQuantity(context, index),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        String _initialQuantity = snapshot.data.toString();
                        myController.text = _initialQuantity;
                        return TextFormField(
                          controller: myController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 18.0)),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onEditingComplete: () {
                            _setQuantity(context, index, snapshot.data);
                          },
                        );
                      } else {
                        return TextFormField(
                          initialValue: "E",
                        );
                      }
                    })),
            _incrementButton(context, index),
          ],
        ),
      ),
    );
  }
}
