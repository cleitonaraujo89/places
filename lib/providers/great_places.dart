import 'dart:io';
import 'dart:math';

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

  void addPlace(String title, File image){
    final newPlace = Place(id: Random().nextDouble().toString(), title: title, location: PlaceLocation(latitude: 105.5, longitude: 522), image: image,);

    _items.add(newPlace);
    notifyListeners();
  }
}