import 'package:alumnimeet/location/location.dart';
import 'package:alumnimeet/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String userId;
  final double lat, lng;

  const MapPage(
      {Key? key, required this.userId, required this.lat, required this.lng})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String? address;
  late final double _lat, _lng;

  @override
  void initState() {
    super.initState();
    _lat = widget.lat;
    _lng = widget.lng;
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(MAP_TITLE)),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(_lat, _lng), zoom: 14.4746),
                markers: _createMarker(),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(4),
              height: 50,
              child: ElevatedButton(
                  child: Text(DONE),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Set<Marker> _createMarker() {
    getAddressFromLatLng(_lat, _lng).then((value){
      setState(() {
        address = value;
      });
    });
    return {
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(_lat, _lng),
       infoWindow: InfoWindow(title: ADDRESS, snippet: address)

      ),
    };
  }
}
