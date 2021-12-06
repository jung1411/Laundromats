import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:laundromats/laundromat_registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  Geolocator geolocator = Geolocator();
  String _currentLocation = '';
  double latitude = 0.0;
  double longitude = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Laundromats")),
      body: ScaffoldBodyContent(),
    );
  }
}

String address = '';
final laundromatsNearby =
    FirebaseFirestore.instance.collection('laundromatsNearby');
final myFirestoreData = FirebaseFirestore.instance;

class ScaffoldBodyContent extends StatelessWidget {
  final center = LatLng(43.92484, -78.87578);
  List<LatLng> coordinates = [];
  final List<Marker> _markers = [
    Marker(
        point: LatLng(43.92220383, -78.87558349),
        builder: (BuildContext context) {
          return const Icon(
            Icons.gps_fixed,
            color: Colors.blue,
          );
        })
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: laundromatsNearby.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var docData;
          for (var i = 0; i < snapshot.data.docs.length; i++) {
            //print(i);
            docData = snapshot.data.docs[i].data();
            GeoPoint geoPoint = docData['location'];
            double price = docData['price'];
            //print(geoPoint);
            double lat = geoPoint.latitude;
            double lng = geoPoint.longitude;
            LatLng latLng = LatLng(lat, lng);
            coordinates.add(latLng);
            //print(coordinates);
            _markers.add(Marker(
                point: latLng,
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    //tooltip: 'Increase volume by 10',
                    onPressed: () {
                      //print(price);
                      address = getAddress(lat, lng).toString();
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('You have chosen a laundromat',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  const Text('\nPrice of the laundromat: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('\$' + price.toString() + '\n'),
                                  const Text('Address: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(address.toString()),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LaundromatRegistration(
                                                  name: "placeholder",
                                                  address: address,
                                                  price: price.toString())));
                                },
                                child: const Text("Book Here"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }));
          }

          return FlutterMap(
            options: MapOptions(zoom: 16.0, center: center),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/alpertunaunsal/ckwkv6x5i5hlb14nsjkyjt6p7/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxwZXJ0dW5hdW5zYWwiLCJhIjoiY2t3a3V3cW54MXZtYTJ2bWpyazBjMHBnayJ9.9deBc_Wmn18IQPfZ4hHwVw",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiYWxwZXJ0dW5hdW5zYWwiLCJhIjoiY2t3a3V3cW54MXZtYTJ2bWpyazBjMHBnayJ9.9deBc_Wmn18IQPfZ4hHwVw',
                    'id': 'mapbox.mapbox-streets-v8'
                  }),
              MarkerLayerOptions(markers: _markers),
            ],
          );
        });
  }
}

Future<Position> _getMyLocation() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    Geolocator.requestPermission();
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}

getAddress(double latitude, double longitude) async {
  List<Placemark> placemark =
      await placemarkFromCoordinates(latitude, longitude);
  Placemark placeMark = placemark[0];
  address = placeMark.street.toString() +
      ', ' +
      placeMark.locality.toString() +
      ', ' +
      placeMark.administrativeArea.toString();
  //print(placeMark.street);
}
