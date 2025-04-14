// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

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
              ? Text('Localização não informada')
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
              onPressed: () {},
              label: Text(
                'Localização Atual',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              icon: Icon(Icons.location_on),
            ),
             TextButton.icon(
              onPressed: () {},
              label: Text(
                'Selecione no mapa',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              icon: Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
