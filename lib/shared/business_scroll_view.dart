import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:iluvfood/models/business.dart';

import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/customer_drawer.dart';
import 'package:iluvfood/shared/single_business_view.dart';
import 'package:provider/provider.dart';

class BusinessScrollView extends StatefulWidget {
  final Customer customer;
  final AuthService auth;
  BusinessScrollView({this.customer, this.auth});
  @override
  _BusinessScrollViewState createState() => _BusinessScrollViewState();
}

class _BusinessScrollViewState extends State<BusinessScrollView> {
  @override
  Widget build(BuildContext context) {
    final businesses = Provider.of<List<Business>>(context) ?? [];
    return Scaffold(
      drawer: TestDrawer(auth: widget.auth),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Hi there, ${widget.customer.name ?? "<no name found>"}!',
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
              return Padding(
                  child: _MyListItem(itemIndex, businesses),
                  padding: EdgeInsets.all(16));
            }
            return Divider(
              height: 10,
              color: MyColors.myGreen,
              thickness: 2,
            );
          }, childCount: math.max(0, businesses.length * 2 - 1))),
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;
  final List<Business> businesses;

  _MyListItem(this.index, this.businesses, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LimitedBox(
        maxHeight: 48,
        child: Container(
          child: FlatButton(
            // color: Theme.of(context).accentColor,
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SingleBusinessView(business: businesses[index])));
            }),
            child: Center(
              child: Text(
                "${businesses[index].businessName},\n ${businesses[index].address}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
