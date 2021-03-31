import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:iluvfood/shared/single_business_view.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class CustomerFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get businessIds
    // get list of businesses
    return StreamBuilder<Customer>(
        stream:
            DatabaseService(uid: Provider.of<User>(context).uid).customerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Customer customer = snapshot.data;
            List businessIDs = customer.favorites;
            return FutureBuilder(
                future: DatabaseService().getBusinesses(businessIDs),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Business>> snapshot) {
                  if (snapshot.hasData) {
                    final List<Business> businessList = snapshot.data;
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          title: Text(
                            'Favorite Suppliers',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                          elevation: 0.0,
                          centerTitle: true,
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 12)),
                        businessList.length == 0
                            ? SliverToBoxAdapter(
                                child: Padding(
                                    child: _NoFavorites(),
                                    padding: EdgeInsets.all(16)))
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                final int itemIndex = index ~/ 2;

                                if (index.isEven) {
                                  return Padding(
                                      child: _MyListItem(
                                          customer, itemIndex, businessList),
                                      padding: EdgeInsets.all(16));
                                }

                                return Divider(
                                  height: 10,
                                  color: MyColors.myGreen,
                                  thickness: 2,
                                );
                              },
                                    childCount: math.max(
                                        0, businessList.length * 2 - 1))),
                      ],
                    );
                  } else {
                    return Loading();
                  }
                });
          } else {
            return Loading();
          }
        });
  }
}

class _NoFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LimitedBox(
        maxHeight: 48,
        child: Container(
          child: TextButton(
              onPressed: (() {}),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "You don't have any favorite suppliers yet.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black),
                ),
              ])),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LimitedBox(
        maxHeight: 80,
        child: Container(
          child: TextButton(
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleBusinessView(
                            business: businesses[index], customer: customer)));
              }),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: Image.network(
                    businesses[index].image,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 30.0),
                Container(
                  width: 200.0,
                  height: 60.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${businesses[index].businessName}",
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                      Flexible(
                        child: Text(
                          "${businesses[index].address}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
