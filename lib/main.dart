import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //region  vars

  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(37.5665, 126.9780);

  //endregion
  //region utility methods
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final getGoogleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in getGoogleOffices.offices) {
        final marker = Marker(markerId: MarkerId(office.name), position: LatLng(office.lat, office.lng), infoWindow: InfoWindow(title: office.name, snippet: office.address,onTap: (){
          Fluttertoast.showToast(msg: "${office.name}");

        }));
        _markers[office.name] = marker;
      }
    });
  }

  //endregion
  //region ovverides
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("title"),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: _markers.values.toSet(),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
//endregion
}
