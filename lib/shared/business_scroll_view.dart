import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              title: Text(
                'Hi there, ${widget.customer.name ?? "<no name found>"}!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
              backgroundColor: Colors.pink,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await widget.auth.signOut();
                  },
                  label: Text(
                    'logout',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                )
              ]),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return _MyListItem(index, businesses);
          }, childCount: businesses.length)),
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
          child: RaisedButton(
            color: Colors.pink[400],
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SingleBusinessView(business: businesses[index])));
            }),
            child: Center(
              child: Text(
                businesses[index].businessName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
