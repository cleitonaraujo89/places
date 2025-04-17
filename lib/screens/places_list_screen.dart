// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:places/providers/great_places.dart';
import 'package:provider/provider.dart';
import '../utils/app_routes.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Lugares',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
            },
            icon: Icon(Icons.add),
          )
        ],
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Consumer<GreatPlaces>(
                //se n tiver lugares na lista, mostra o chield, caso contrario mostra a lista
                builder: (ctx, greatPlaces, ch) => greatPlaces.itemsCount == 0
                    ? ch!
                    : ListView.builder(
                        itemCount: greatPlaces.itemsCount,
                        itemBuilder: (cts, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.items[i].image),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          subtitle:
                              Text(greatPlaces.items[i].location!.address!),
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.PLACE_DETAIL, arguments: greatPlaces.items[i]);
                          },
                        ),
                      ),
                child: Center(
                  child: Text('Nenhum Local Cadastrado!'),
                ),
              ),
      ),
    );
  }
}
