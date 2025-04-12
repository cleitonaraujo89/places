import 'package:flutter/material.dart';
import 'package:places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  final List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }
  
  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int i){
    return _items[i];
  }
}