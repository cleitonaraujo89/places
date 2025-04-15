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
}
