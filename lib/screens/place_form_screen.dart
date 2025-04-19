import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../widgets/location_input.dart';
import '../widgets/image_input.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({super.key});

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  LatLng? _pickedPosition;

  void _selectedImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;      
    });
  }

  void _selectedPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;      
    });
  }

  //validação simples
  bool isValidForm() {
    return _titleController.text.isNotEmpty &&
        _pickedImage != null &&
        _pickedPosition != null;
  }

  void _submitForm() {
    if (!isValidForm()) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!, _pickedPosition!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Lugar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Expanded para ocupar o espaço de tela e deixar o butoon no rodapé
          Expanded(
            //E o ScrollView é uma proteção para garantir que haja a rolagem dentro desse
            //bloco, mantendo o button em baixo e n escondendo nenhum objeto da tela
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Titulo',
                      ),
                      controller: _titleController,
                    ),
                    const SizedBox(height: 10),
                    ImageInput(_selectedImage),
                    const SizedBox(height: 10),
                    LocationInput(_selectedPosition),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: isValidForm() ? _submitForm : null,
            label: const Text('Adicionar'),
            icon: const Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              elevation: 0,
              shape: const RoundedRectangleBorder(),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
