

import 'package:alumnimeet/location/location.dart';
import 'package:alumnimeet/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MultiMarkerMap extends StatefulWidget {
  final List allUsers;
  const MultiMarkerMap({Key? key,
  required this.allUsers})
      : super(key: key);

  @override
  _MultiMarkerMapState createState() => _MultiMarkerMapState();
}

class _MultiMarkerMapState extends State<MultiMarkerMap> {
   Map<String, Marker> _markers = {};
  late List _allUser = widget.allUsers;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    Map<String, Marker> markers = {};
    for (var userSnapshot in _allUser) {
      User user = User.fromDocumentSnapShot(userSnapshot);
      if (user.lat != null && user.lng != null) {
        String address = await getAddressFromLatLng(user.lat!, user.lng!);
        LatLng latLng = new LatLng(user.lat!, user.lng!);
        final marker = Marker(
          markerId: MarkerId(user.userid),
          position: latLng,
          infoWindow: InfoWindow(title: user.name, snippet: address),
          /* onTap: () {
              var bottomSheetController = scaffoldKey.currentState!
                  .showBottomSheet((context) => Container(
                        child: getBottomSheet(user, address),
                        height: 250,
                        color: Colors.transparent,
                      ));
            }*/
        );
        markers[user.userid] = marker;
      }
    }
    setState(() {
      _markers.addAll(markers) ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Alumni Members Locations'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: const LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );

  }
}
