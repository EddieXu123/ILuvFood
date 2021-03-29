// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/services/database.dart';

class CartModel extends ChangeNotifier {
  String businessUid;
  String businessName;
  final _databaseService = DatabaseService();
  double _priceInCart = 0;

  CartModel({this.businessUid, this.businessName});

  /// Internal, private state of the cart. Stores the item-name:cart_item
  final Map<String, CartItem> _itemMap = Map();

  // get itemids map
  List<CartItem> get cartItems {
    return _itemMap.values.toList();
  }

  void reset() {
    print("resetting cart!");
    _priceInCart = 0;
    businessUid = '';
    businessName = '';
    _itemMap.clear();
  }

  /// The current total price of all items.
  double get priceInCart {
    return _priceInCart;
    // try {
    //   _itemMap.forEach((k, v) async {
    //     var item = await _databaseService.readBusinessItem(businessUid, k);
    //     // print("calculating price for ${item.item}");
    //     // print("adding price of ${item.price}");
    //     _priceInCart += int.parse(item.price);
    //   });
    //   return _priceInCart;
    //   // print(_priceInCart);

    // } catch (e) {
    //   print("error calculating price: $e");
    //   return null;
    // }
  }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  Future<void> add(String itemId) async {
    try {
      var item = await _databaseService.readBusinessItem(businessUid, itemId);
      // print("calculating price for ${item.item}");
      // print("adding price of ${item.price}");
      _priceInCart += double.parse(item.price);
      if (_itemMap.containsKey(item.item)) {
        _itemMap.update(
            item.item,
            (value) => CartItem(
                item: value.item,
                uid: value.uid,
                quantity: value.quantity + 1,
                price: item.price));
      } else {
        _itemMap[item.item] = CartItem(
            item: item.item, uid: itemId, quantity: 1, price: item.price);
      }
      print("Added, cart total now: $_priceInCart");
      print(
          "quantity of ${item.item} in cart: ${_itemMap[item.item].quantity}");

      // todo: probably makes sense to also check if there is enough inventory?
      notifyListeners();
    } catch (e) {
      print("could not put in dict:  $e");
    }
  }

  /// Removes [item] to cart. This is the only way to modify the cart from outside.
  Future<void> remove(String itemId) async {
    try {
      var item = await _databaseService.readBusinessItem(businessUid, itemId);
      // print("calculating price for ${item.item}");
      // print("adding price of ${item.price}");
      if (_itemMap.containsKey(item.item)) {
        // _priceInCart -= int.parse(item.price);
        if (_itemMap[item.item].quantity == 1) {
          _itemMap.remove(item.item);
        } else {
          _itemMap.update(
              item.item,
              (value) => CartItem(
                  item: value.item,
                  uid: value.uid,
                  quantity: value.quantity - 1));
        }
      } else {
        print("could not find item in map");
      }
      print("Removed, cart total now: $_priceInCart");
      // todo: probably makes sense to also check if there is enough inventory?
      notifyListeners();
    } catch (e) {
      print("could not remove from dict:  $e");
    }
  }

  Future<void> delete(String itemId) async {
    try {
      var item = await _databaseService.readBusinessItem(businessUid, itemId);
      // print("calculating price for ${item.item}");
      // print("adding price of ${item.price}");
      if (_itemMap.containsKey(item.item)) {
        var totalQuantity = _itemMap[item.item].quantity;
        print("Total Quantity: $totalQuantity");
        var cost = double.parse(item.price);
        print("Cost Of Item: $cost");
        var totalRemovedCost = totalQuantity * cost;

        _priceInCart -= totalRemovedCost;

        //if (_itemMap[item.item].quantity == 1) {
        _itemMap.update(item.item,
            (value) => CartItem(item: value.item, uid: value.uid, quantity: 0));
        _itemMap.remove(item.item);
        //} else {
        // _itemMap.update(item.item,
        //     (value) => CartItem(item: value.item, uid: value.uid, quantity: 0));
        //}
      } else {
        print("could not find item in map");
      }
      print("Removed, cart total now: $_priceInCart");
      // todo: probably makes sense to also check if there is enough inventory?
      notifyListeners();
    } catch (e) {
      print("could not put in dict:  $e");
    }
  }

  /// Get quantity of  [item] in cart.
  Future<int> getQuantity(String itemId) async {
    try {
      var item = await _databaseService.readBusinessItem(businessUid, itemId);
      if (_itemMap.containsKey(item.item)) {
        var quantity = _itemMap[item.item].quantity;
        if (quantity != null) {
          return quantity;
        }
      }
      return 0;
      return (_itemMap.containsKey(item.item))
          ? _itemMap[item.item].quantity
          : 0;
    } catch (e) {
      print("could not get quantity:  $e");
      return 0;
    }
  }

  // void removeNoInventory(String itemId) {
  //   print("Removing from cart, items sold out");
  //   remove(itemId);
  // }

  // void remove(String itemId) {
  //   _itemIds.remove(itemId);
  //   // Don't forget to tell dependent widgets to rebuild _every time_
  //   // you change the model.
  //   notifyListeners();
  // }
}
