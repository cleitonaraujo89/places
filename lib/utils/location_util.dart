import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../configs/google_api_key.dart';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {

    //link da api obtida em: https://developers.google.com/maps/documentation/maps-static/overview?hl=pt-br
    //resultado da busca de 'google maps static api' (no google)
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${GoogleApiKey.getApiKey}';
  }

  //link da api de geocode reversa, aonde passamos lat. e long. e pegamos o endereço
  static Future<String> getAddressFrom(LatLng position) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${GoogleApiKey.getApiKey}';

    final response = await http.get(Uri.parse(url));
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
