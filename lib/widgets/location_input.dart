// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places/screens/map_screen.dart';
import 'package:places/utils/location_util.dart';

class LocationInput extends StatefulWidget {
  const LocationInput(this.onSelectedPosition, {super.key});
  final Function onSelectedPosition;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  // ---------------- PEGA O LOCAL ATUAL DO USUÁRIO -----------------
  Future<void> _getCurrentUserLocation() async {
    final location = Location();

    final bool check = await permissionsCheck();
    if (!check) {
      return;
    }

    //pega a localização do usuário
    try {
      final locData = await location.getLocation();

      //retorna uma string (URL) interpolada com as informações nescessárias para api gerar a imagem
      final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
          latitude: locData.latitude, longitude: locData.longitude);

      //passa a url e abaixo a função do pai atualiza o estado para carregar a imagem
      _previewImageUrl = staticMapImageUrl;

      widget.onSelectedPosition(LatLng(locData.latitude!, locData.longitude!));
    } catch (e) {
      _showErrorDialog(context, 'Erro ao obter a localização.');
    }
  }

  // -----------  SELECIONAR LOCAL NO MAPA -----------------
  Future<void> _selectOnMap() async {
    final bool check = await permissionsCheck();
    if (!check) {
      return;
    }

    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (selectedPosition == null) {
      return;
    }

    _previewImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: selectedPosition.latitude,
        longitude: selectedPosition.longitude);

    widget.onSelectedPosition(selectedPosition);
  }

  //----------FUNÇÃO DE ALERTA ---------
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ops!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  //-------- VERIFICA PERMISSÕES ------
  Future<bool> permissionsCheck() async {
    bool serviceEnabled;
    final location = Location();
    PermissionStatus permissionGranted;

    // Verifica se o serviço de localização está ativado (gps ligado)
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _showErrorDialog(context, 'Serviço de localização desativado.');
        return false;
      }
    }

    // Verifica a permissão
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _showErrorDialog(context, 'Permissão de localização negada.');
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text('Localização não informada')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              label: Text(
                'Localização Atual',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: Text(
                'Selecione no mapa',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              icon: const Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
