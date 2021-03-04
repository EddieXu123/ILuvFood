// import 'package:iluvfood/shared/errorPage.dart';

// import 'package:flutter/material.dart';

// class Checkout extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ErrorPage();
//   }
// }
// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:provider/provider.dart';

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            Divider(height: 4, color: Colors.black),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    // var cart = context.watch<CartModel>();
    CartModel cart = context.watch<CartModel>();
    return ListView.builder(
      itemCount: cart.cartItems.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.done),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            cart.remove(cart.cartItems[index].uid);
          },
        ),
        title: Text(
          "${cart.cartItems[index].item} (${cart.cartItems[index].quantity})",
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // CartModel cart = context.watch<CartModel>();
    var hugeStyle =
        Theme.of(context).textTheme.headline1.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Another way to listen to a model's change is to include
            // the Consumer widget. This widget will automatically listen
            // to CartModel and rerun its builder on every change.
            //
            // The important thing is that it will not rebuild
            // the rest of the widgets in this build method.
            Consumer<CartModel>(
                builder: (context, cart, child) =>
                    Text('\$${cart.priceInCart}', style: hugeStyle)),
            SizedBox(width: 24),
            TextButton(
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Buying not supported yet.')));
              },
              child: Text(
                'BUY',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
