import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/providers/expense_provider.dart';

import '../../../models/Address.dart';

class AddressCard extends StatefulWidget {
  Address address;
  AddressCard({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  Completer<GoogleMapController> _controller = Completer();

  Future<void> moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: widget.address.latLng,
      zoom: 16,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(widget.address.name),
              ],
            ),
            Container(
              height: 200,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: widget.address.latLng,
                  zoom: 16,
                ),
                compassEnabled: false,
                myLocationButtonEnabled: false,
                scrollGesturesEnabled: false,
                tiltGesturesEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
                mapToolbarEnabled: false,
                markers: {
                  Marker(
                    markerId: MarkerId("pont"),
                    position: widget.address.latLng,
                    draggable: false,
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  moveCamera();
                },
              ),
            ),
            MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MapLocationPicker(
                          apiKey: "AIzaSyDUrrqoBjEPT_nOk_ZkaJ4nK0CGQcVKxNM",
                          canPopOnNextButtonTaped: true,
                          currentLatLng: widget.address.latLng,
                          onNext: (GeocodingResult? result) {
                            if (result != null) {
                              setState(() {
                                widget.address = Address(
                                    name: result.formattedAddress ?? "",
                                    latitude: result.geometry.location.lat,
                                    longitude: result.geometry.location.lng
                                );
                                context.read<ExpenseProvider>().setAddress(widget.address);
                                moveCamera();
                              });
                            }
                          },
                          onSuggestionSelected: (PlacesDetailsResponse? result) {
                            if (result != null) {
                              setState(() {
                                widget.address = Address(
                                    name: result.result.formattedAddress ?? "",
                                    latitude: result.result.geometry?.location.lat,
                                    longitude: result.result.geometry?.location.lng
                                );
                                context.read<ExpenseProvider>().setAddress(widget.address);
                              });
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                child: Text("Hely megadása")
            ),
          ],
        ),
      ),
    );
  }
}