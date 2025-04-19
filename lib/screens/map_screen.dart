import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key, this.initialLocation =
          const PlaceLocation(latitude: 37.419857, longitude: -122.078827),
      this.isReadOnly = false});

  final PlaceLocation initialLocation;
  final bool isReadOnly;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione...'),
        actions: [
          //se readyOnly for falso e o user clicar no mapa ai aparece o icone, e quando o user
          //clica no icone fecha a telaretornando a posição escolhida
          if (!widget.isReadOnly)
            IconButton(
                onPressed: _pickedPosition == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedPosition);
                      },
                icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        //define aonde a camera começa inicialmente
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        //se o mapa nao for de somente leitura permite selecionar a posição, o ontap aqui
        //no GoogleMap passa um LatLng contendo a Latitude e Longitude do local clicado
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: (_pickedPosition == null && !widget.isReadOnly)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position:
                      _pickedPosition ?? widget.initialLocation.toLatLng(),
                ),
              },
      ),
    );
  }
}
