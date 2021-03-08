import 'package:flutter/material.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';

import 'package:iluvfood/shared/restaurants.dart' as restaurants;

// TODO: my location button: https://pub.dev/documentation/google_maps_flutter/latest/google_maps_flutter/GoogleMap/myLocationButtonEnabled.html

void main() => runApp(Home());

/*
Customer landing page after they log in
*/
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  GoogleMapController mapController;

  final LatLng _center = const LatLng(41.4993, -81.6944);
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final query = "1867 W 25th St, Cleveland, OH 44113";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");

    final locations = await restaurants.getLocations();
    setState(() {
      _markers.clear();
      for (final restaurant in locations.restaurants) {
        final marker = Marker(
          markerId: MarkerId(restaurant.name),
          position: LatLng(restaurant.lat, restaurant.lng),
          infoWindow: InfoWindow(
            title: restaurant.name,
            snippet: restaurant.address,
            // TODO: onTap callback: https://pub.dev/documentation/google_maps_flutter_platform_interface/latest/google_maps_flutter_platform_interface/InfoWindow-class.html
          ),
        );
        _markers[restaurant.name] = marker;
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
            title: Text('iLuvFood Landing Page'),
            backgroundColor: Colors.pink,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                onPressed: () async {
                  await _auth.signOut();
                },
                label: Text('logout'),
              )
            ]),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
