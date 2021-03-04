import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/business_item.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class SingleBusinessView extends StatefulWidget {
  final Business business;
  SingleBusinessView({this.business});
  @override
  _SingleBusinessViewState createState() => _SingleBusinessViewState();
}

class _SingleBusinessViewState extends State<SingleBusinessView> {
  // expose the data

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BusinessItem>>(
        stream: DatabaseService().getBusinessItem(widget.business),
        builder: (context, snapshot) {
          // if (snapshot.hasData) {
          //   return ItemScrollView(businessItems: snapshot.data);
          // } else {
          //   return Loading();
          // }

          return Scaffold(
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
                      child: snapshot.hasData
                          ? ItemScrollView(businessItems: snapshot.data)
                          : Loading(),
                    )
                  ],
                )
              ]));
        });
  }
}

class ItemScrollView extends StatefulWidget {
  final List<BusinessItem> businessItems;
  ItemScrollView({this.businessItems});
  @override
  _ItemScrollViewState createState() => _ItemScrollViewState();
}

class _ItemScrollViewState extends State<ItemScrollView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return _MyListItem(index, widget.businessItems);
          }, childCount: widget.businessItems.length)),
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;
  final List<BusinessItem> businessItems;

  _MyListItem(this.index, this.businessItems, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: LimitedBox(
        maxHeight: 48,
        child: Container(
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: (() {}),
            child: Center(
                child: Column(
              children: [
                Text(
                  "Entree: ${businessItems[index].item}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
                Text(
                  "Price: \$${businessItems[index].price}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
                Text(
                  "Qty: ${businessItems[index].quantity}",
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
