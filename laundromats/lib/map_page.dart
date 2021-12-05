import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'main.dart';
import 'package:firebase_core/firebase_core.dart';
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
      appBar: AppBar(title: Text("Nearby Laundromats")),
      body: ScaffoldBodyContent(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var position = await _getMyLocation();
      //     setState(() {
      //       _currentLocation =
      //           "Position(${position.latitude}, ${position.longitude})";
      //       latitude = position.latitude;
      //       longitude = position.longitude;
      //       getAddress(latitude, longitude);
      //     });
      //     print(position);
      //     getData();
      //     // _markers.add(Marker(
      //     //     point: LatLng(latitude, longitude),
      //     //     builder: (BuildContext context) {
      //     //       return Icon(
      //     //         Icons.circle,
      //     //         color: Colors.blue,
      //     //       );
      //     //     }));
      //     //_polylines.add(Polyline(points: [LatLng(latitude, longitude)]));
      //     _coord.add(LatLng(latitude, longitude));
      //   },
      //   child: const Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // )
    );
  }
}

String address = '';
final laundromatsNearby =
    FirebaseFirestore.instance.collection('laundromatsNearby');
final myFirestoreData = FirebaseFirestore.instance;

CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('laundromatsNearby');

Future<void> getData() async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  // var docData = snapshot.data.docs['laundro1'].data();

  // print(allData);

  // myFirestoreData
  //     .collection("laundromantsNearby") // your collection
  //     // .doc('laundro1') //your document
  //     // .collection("location") //your collection
  //     .get()
  //     .then((QuerySnapshot x) {
  //   x.docs.forEach((f) {
  //     print('${f.data}}');
  //     // GeoPoint pos = f.data['position'];
  //     // LatLng latLng = new LatLng(pos.latitude, pos.longitude);
  //   });
  // });

  print(_collectionRef.doc('laundro1').snapshots());
}

class ScaffoldBodyContent extends StatelessWidget {
  final center = LatLng(43.92484, -78.87578);
  List<LatLng> coordinates = [];
  List<Marker> _markers = [
    Marker(
        point: LatLng(43.92220383, -78.87558349),
        builder: (BuildContext context) {
          return Icon(
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
            return CircularProgressIndicator();
          }
          var docData;
          for (var i = 0; i < snapshot.data.docs.length; i++) {
            print(i);
            docData = snapshot.data.docs[i].data();
            GeoPoint geoPoint = docData['location'];
            double price = docData['price'];
            //print(geoPoint);
            double lat = geoPoint.latitude;
            double lng = geoPoint.longitude;
            LatLng latLng = new LatLng(lat, lng);
            coordinates.add(latLng);
            print(coordinates);
            _markers.add(Marker(
                point: latLng,
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    tooltip: 'Increase volume by 10',
                    onPressed: () {
                      print(price);
                      address = getAddress(lat, lng).toString();
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('You have chosen a laundromat',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Price of the laundromat: \$' +
                                      price.toString()),
                                  Text('Address: ' + address.toString()),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
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
              // PolylineLayerOptions(polylines: [
              //   Polyline(
              //       color: Colors.blueAccent, strokeWidth: 2.0, points: _coord),
              // ]),
            ],
          );
        });
  }
}

// Widget _buildMarkers(BuildContext context) {
//   return StreamBuilder(
//       stream: laundromatsNearby.snapshots(),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//         return
//       });
// }

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
  print(placeMark.street);
}
