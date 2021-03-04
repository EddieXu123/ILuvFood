// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:iluvfood/services/database.dart';

class CartModel extends ChangeNotifier {
  final String businessUid;
  final _databaseService = DatabaseService();

  CartModel({this.businessUid});

  /// Internal, private state of the cart. Stores the itemid:qty
  final Map<String, int> _itemMap = Map();

  // get itemids map
  Map<String, int> get itemsIds => _itemMap;

  /// The current total price of all items.
  Future<int> get totalPrice async {
    int totalPrice = 0;
    try {
      _itemMap.forEach((k, v) async {
        var item = await _databaseService.readBusinessItem(businessUid, k);
        print("calculating price for ${item.item}");
        totalPrice += int.parse(item.price);
      });
      return totalPrice;
    } catch (e) {
      print("error calculating price: $e");
      return null;
    }
  }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(String itemId) {
    if (_itemMap.containsKey(itemId)) {
      _itemMap.update(itemId, (value) => value + 1);
    } else {
      _itemMap[itemId] = 1;
    }
    print("quantity of $itemId in cart: ${_itemMap[itemId]}");

    // todo: probably makes sense to also check if there is enough inventory?
    notifyListeners();
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
