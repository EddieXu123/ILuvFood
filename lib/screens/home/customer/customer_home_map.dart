import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/shared/single_business_view.dart';
import 'dart:ui' as ui;

// TODO: my location button: https://pub.dev/documentation/google_maps_flutter/latest/google_maps_flutter/GoogleMap/myLocationButtonEnabled.html

/*
Customer landing page after they log in
*/
class CustomerHomeMap extends StatefulWidget {
  final Customer customer;
  final AuthService auth;
  CustomerHomeMap({this.customer, this.auth});
  @override
  _CustomerHomeMapState createState() => _CustomerHomeMapState();
}

class _CustomerHomeMapState extends State<CustomerHomeMap> {
  final AuthService _auth = AuthService();
  GoogleMapController mapController;

  final LatLng _center = const LatLng(41.4993, -81.6944);
  List<Business> businesses = [];
  final Map<String, Marker> _markers = {};
  BitmapDescriptor mapMarkerOpen;
  BitmapDescriptor mapMarkerClosed;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  /// Resizes the marker images
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  /// Loads custom map markers and specifies the size
  void setCustomMarker() async {
    final Uint8List markerIconOpen =
        await getBytesFromAsset('assets/images/map-marker-green.png', 60);
    mapMarkerOpen = BitmapDescriptor.fromBytes(markerIconOpen);

    final Uint8List markerIconClosed =
        await getBytesFromAsset('assets/images/map-marker-red.png', 60);
    mapMarkerClosed = BitmapDescriptor.fromBytes(markerIconClosed);
  }

  /// Loads the restaurants from the database data to markers for the map
  Map<String, Marker> getRestaurants() {
    _markers.clear();

    for (final business in businesses) {
      final marker = Marker(
        markerId: MarkerId(business.businessName),
        position:
            LatLng(double.parse(business.lat), double.parse(business.lng)),
        icon: mapMarkerOpen,
        infoWindow: InfoWindow(
          title: business.businessName,
          snippet: business.address,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SingleBusinessView(business: business)));
          },
          // TODO: onTap callback: https://pub.dev/documentation/google_maps_flutter_platform_interface/latest/google_maps_flutter_platform_interface/InfoWindow-class.html
        ),
      );
      _markers[business.businessName] = marker;
    }

    return _markers;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    businesses = Provider.of<List<Business>>(context) ?? [];
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
            title: Text(
              'Hi there, ${widget.customer.name ?? "<no name found>"}!',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
            ),
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
            zoom: 11,
          ),
          markers: getRestaurants().values.toSet(),
          //markers: _markers.values.toSet(),
        ),
        //TODO: floatingActionButton for mylocation?
      ),
    );
  }
}
