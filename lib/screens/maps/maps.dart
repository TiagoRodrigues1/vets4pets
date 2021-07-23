import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;
import 'package:flutter/material.dart';

class MapsPage extends StatefulWidget {
  MapsPage({Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;
  Position _currentPosition;
final Map<String, Marker> _markers = {};
double lat, lng;

  CameraPosition cameraPosition = null;

  void initState() {
    this._getCurrentLocation();
    super.initState();
  }


Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices(lat,lng);
  
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }


  _getCurrentLocation() {
    
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        LatLng coords = LatLng(position.latitude, position.longitude);
        lat=position.latitude;
        lng= position.longitude;
        cameraPosition = CameraPosition(target: coords, zoom: 11);
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Near Vets'),
      ),
      body: cameraPosition != null
          ? GoogleMap(
             onMapCreated: _onMapCreated,
              mapType: MapType.satellite,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: cameraPosition,
              markers: _markers.values.toSet(),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
