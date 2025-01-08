import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../components/placemark_widget.dart';

class SelectLocationPage extends StatefulWidget {
  final void Function(LatLng) onLocationSelected;

  const SelectLocationPage({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: dicodingOffice,
              ),
              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              onMapCreated: (controller) async {
                final info = await geo.placemarkFromCoordinates(
                    dicodingOffice.latitude, dicodingOffice.longitude);
                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                setState(() {
                  placemark = place;
                });
                defineMarker(dicodingOffice, street, address);

                setState(() {
                  mapController = controller;
                });
              },
              onLongPress: (LatLng latLng) {
                onLongPressGoogleMap(latLng);
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () {
                  onMyLocationButtonPress();
                },
              ),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 80.0,
                right: 16.0,
                left: 16.0,
                child: Placemark(
                  placemark: placemark!,
                ),
              ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: FilledButton(
                onPressed: () {
                  if (markers.isNotEmpty) {
                    final selectedLatLng = markers.first.position;
                    context.pop(selectedLatLng);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Select a location on the map'),
                      ),
                    );
                  }
                },
                child: const Text('Select Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street!, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
