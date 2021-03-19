import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:iluvfood/models/business.dart';

import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/customer_drawer.dart';
import 'package:iluvfood/shared/single_business_view.dart';
import 'package:iluvfood/services/database.dart';
import 'package:provider/provider.dart';

class CustomerFavoritesList extends StatefulWidget {
  final Customer customer;
  final AuthService auth;
  CustomerFavoritesList({this.customer, this.auth});
  @override
  _CustomerFavoritesListState createState() => _CustomerFavoritesListState();
}

class _CustomerFavoritesListState extends State<CustomerFavoritesList> {
  final _databaseService = DatabaseService();
  List businessesIDs;
  Future<List<Business>> businesses;

  @override
  void initState() {
    super.initState();
    businessesIDs = widget.customer.favorites;
    businesses = getBusinesses(businessesIDs);
  }

  @override
  void didUpdateWidget(CustomerFavoritesList oldWidget) {
    if (oldWidget.customer.favorites != widget.customer.favorites) {
      initState();
    }
  }

  Future<List<Business>> getBusinesses(List businessesIDs) async {
    List<Business> businesses = [];
    for (var i = 0; i < businessesIDs.length; i++) {
      Business newBusiness =
          await _databaseService.readBusiness(businessesIDs[i]);
      businesses.add(newBusiness);
    }
    return businesses;
  }

  @override
  Widget build(BuildContext context) {
    //final businesses = Provider.of<List<Business>>(context) ?? [];

    return Scaffold(
      drawer: TestDrawer(auth: widget.auth),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Favorite Restaurants',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
            ),
            elevation: 0.0,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            final int itemIndex = index ~/ 2;
            if (index.isEven) {
              return FutureBuilder(
                future: businesses,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Business>> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        child: _MyListItem(
                            widget.customer, itemIndex, snapshot.data),
                        padding: EdgeInsets.all(16));
                  } else {
                    return Text('You have no favorite restaurants.');
                  }
                },
              );
            }
            return Divider(
              height: 10,
              color: MyColors.myGreen,
              thickness: 2,
            );
          }, childCount: math.max(0, businessesIDs.length * 2 - 1))),
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final Customer customer;
  final int index;
  final List<Business> businesses;

  _MyListItem(this.customer, this.index, this.businesses, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var item = context.select<CatalogModel, Item>(
    //   // Here, we are only interested in the item at [index]. We don't care
    //   // about any other change.
    //   (catalog) => catalog.getByPosition(index),
    // );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LimitedBox(
        maxHeight: 48,
        child: Container(
          child: TextButton(
              // color: Theme.of(context).accentColor,
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleBusinessView(
                            business: businesses[index], customer: customer)));
              }),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: Image.network(
                    businesses[index].image,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 30.0),
                Text(
                  "${businesses[index].businessName}\n ${businesses[index].address}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
              ])),
        ),
      ),
    );
  }
}
