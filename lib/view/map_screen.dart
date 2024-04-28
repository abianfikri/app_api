import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.onLocationSelected});
  final Function(String) onLocationSelected;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? lastMapPosition;
  final searchController = TextEditingController();

  // Request location permissions
  // Fetch the current location
  Future getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });

    // Get the current position
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lastMapPosition = LatLng(position.latitude, position.longitude);
    });
    mapController.animateCamera(CameraUpdate.newLatLng(lastMapPosition!));
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (lastMapPosition != null) {
      setState(() {
        mapController.animateCamera(CameraUpdate.newLatLng(lastMapPosition!));
      });
    }
  }

  // Implementasi fungsi searchPlace
  void searchPlace(String placeName) async {
    List<Location> locations = await locationFromAddress(placeName);
    if (locations.isNotEmpty) {
      Location location = locations[0];
      LatLng searchedPosition = LatLng(location.latitude, location.longitude);

      setState(() {
        lastMapPosition = searchedPosition;
      });

      mapController.animateCamera(CameraUpdate.newLatLng(searchedPosition));
    } else {
      // Handle case when no location is found for the given address.
      // You can display an error message or take appropriate action.
      print("No location found for the given address: $placeName");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Search Location'),
                    content: TextField(
                      controller: searchController,
                      decoration: InputDecoration(hintText: 'Enter location'),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Search'),
                        onPressed: () {
                          String searchTerm = searchController.text;
                          if (searchTerm.isNotEmpty) {
                            searchPlace(searchTerm);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        trafficEnabled: true,
        // on below line setting compass enabled.
        compassEnabled: true,
        onMapCreated: onMapCreated,
        //mapType: MapType.normal,),
        initialCameraPosition: CameraPosition(
          target: lastMapPosition ?? const LatLng(0.0, 0.0),
          zoom: 15.0,
        ),
        markers: {
          if (lastMapPosition != null)
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: lastMapPosition!,
            )
        },
        onTap: (position) {
          setState(() {
            lastMapPosition = position;
          });
        },
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (lastMapPosition != null) {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  lastMapPosition!.latitude,
                  lastMapPosition!.longitude,
                );

                if (placemarks.isNotEmpty) {
                  Placemark place = placemarks[0];
                  String fullAddress =
                      "${place.name},${place.street},${place.subLocality},${place.locality},${place.postalCode},${place.country}";
                  widget.onLocationSelected(fullAddress);
                } else {
                  widget.onLocationSelected("No address found");
                }

                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
