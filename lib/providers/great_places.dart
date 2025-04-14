import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:places/models/place.dart';
import 'package:places/utils/db_util.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  Future<void> loadPlaces() async {
     // Busca todos os dados armazenados na tabela 'places' do banco
    final dataList = await DbUtil.getData('places');

    // Converte a lista de mapas em uma lista de objetos do tipo Place
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: null,
            ))
        .toList();

    notifyListeners();
  }

  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int i) {
    return _items[i];
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      location: PlaceLocation(latitude: 105.5, longitude: 522),
      image: image,
    );

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
    notifyListeners();
  }
}
