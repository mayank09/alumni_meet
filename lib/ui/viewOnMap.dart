import 'package:alumnimeet/firebase/firestore.dart';
import 'package:alumnimeet/location/location.dart';
import 'package:alumnimeet/models/user.dart';
import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewOnMap extends StatefulWidget {
  final String? userId;
  final double? lat, lng;
  final bool isCurrentUser;
  final bool? isMultipleMarker;
  final List? allUsers;

  const ViewOnMap(
      {Key? key,
      this.userId,
      this.lat,
      this.lng,
      required this.isCurrentUser,
      this.isMultipleMarker,
      this.allUsers})
      : super(key: key);

  @override
  _ViewOnMapState createState() => _ViewOnMapState();
}

class _ViewOnMapState extends State<ViewOnMap> {
  late bool _isCurrentUser;
  late bool? _isMultipleMarker;
  late String? _userId;
  late final double? _lat, _lng;
  late List? _allUsers;
  LatLng? latlng;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _isCurrentUser = widget.isCurrentUser;
    _isMultipleMarker =
        widget.isMultipleMarker != null ? widget.isMultipleMarker : false;
    _userId = widget.userId;
    _cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    if (!_isMultipleMarker!) {
      _lat = widget.lat;
      _lng = widget.lng;
      setMarker();
    } else {
      if (widget.allUsers != null) {
        _allUsers = widget.allUsers;
        if (_allUsers!.isNotEmpty) {
          setMultipleMarker(_allUsers!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_isCurrentUser
              ? "Set Location"
              : _isMultipleMarker!
                  ? "Alumni Map View"
                  : "View Location On Map")),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
                child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
                (latlng != null)
                    ? GoogleMap(
                        initialCameraPosition: _cameraPosition!,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = (controller);
                          _controller!.animateCamera(
                              CameraUpdate.newCameraPosition(_cameraPosition!));
                        },
                        markers: _markers,
                        myLocationEnabled: _isCurrentUser ? true : false,
                        myLocationButtonEnabled: _isCurrentUser ? true : false,
                        onCameraIdle: () {
                          setState(() {});
                        },
                      )
                    : Container(),
              ],
            )),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                child: Text(DONE),
                onPressed: () {
                  if (_isCurrentUser) {
                    updateUserCurrentLocation(
                        _userId!, latlng!.latitude, latlng!.longitude);
                    showSnackBar(context, LOCATION_UPDATED_SUCCESS);
                  }
                  Navigator.pop(context);
                }),
          )
        ],
      ),
    );
  }

  setMarker() async {
    double lat, lng;
    if (_isCurrentUser) {
      Position position = await determinePosition(context);
      if (_lat != null && _lng != null) {
        lat = _lat!;
        lng = _lng!;
      } else {
        lat = position.latitude;
        lng = position.longitude;
      }
    } else {
      lat = _lat!;
      lng = _lng!;
    }
    String address = await getAddressFromLatLng(lat, lng);
    setState(() {
      latlng = new LatLng(lat, lng);
      _cameraPosition = CameraPosition(target: latlng!, zoom: 10.0);
      if (_controller != null)
        _controller!
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      _markers.add(Marker(
          markerId: MarkerId(_userId!),
          draggable: _isCurrentUser ? true : false,
          position: latlng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(_isCurrentUser
              ? BitmapDescriptor.hueRed
              : BitmapDescriptor.hueBlue),
          onDragEnd: (_currentLatLng) {
            latlng = _currentLatLng;
            updateMarker();
          },
          infoWindow: InfoWindow(title: ADDRESS, snippet: address)));
    });
  }

  updateMarker() async {
    String address =
        await getAddressFromLatLng(latlng!.latitude, latlng!.longitude);
    var marker =
        _markers.toList().firstWhere((item) => item.markerId.value == _userId!);
    Marker _marker = Marker(
      markerId: marker.markerId,
      position: LatLng(latlng!.latitude, latlng!.longitude),
      draggable: marker.draggable,
      onDragEnd: marker.onDragEnd,
      icon: marker.icon,
      infoWindow: InfoWindow(title: ADDRESS, snippet: address),
    );
    setState(() {
      _markers.clear();
      _markers.add(_marker);
    });
  }

  void setMultipleMarker(List _allUser) async {
    List<Marker> markers = [];
    for (var userSnapshot in _allUser) {
      User user = User.fromDocumentSnapShot(userSnapshot);
      if (user.userid != _userId && user.lat != null && user.lng != null) {
        String address = await getAddressFromLatLng(user.lat!, user.lng!);
        LatLng latLng = new LatLng(user.lat!, user.lng!);
        markers.add(Marker(
          markerId: MarkerId(user.userid),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
              title: user.name.toUpperCase(),
              snippet: address,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return getBottomSheet(user, address);
                    });
              }),
        ));
      }
    }
    setState(() {
      latlng = LatLng(
          markers.first.position.latitude, markers.first.position.longitude);
      _cameraPosition = CameraPosition(target: latlng!, zoom: 10.0);
      if (_controller != null)
        _controller!
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  Widget getBottomSheet(User user, String address) {
    String ll = user.lat.toString() + "," + user.lng.toString();
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 32),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.work,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                              user.work != null
                                  ? user.work!.org! + ", " + user.work!.city!
                                  : "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.library_books,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                              user.education != null
                                  ? user.education!.org! +
                                      ", " +
                                      user.education!.city!
                                  : "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(address,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      /* Text(address,
                          style: TextStyle(color: Colors.white, fontSize: 14)),*/
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.map,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(ll)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      child: Text(user.email,
                          style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        customLaunch(
                            'mailto: ${user.email} subject: $APP_NAME');
                      })
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.call,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      child: Text(
                          user.phoneNumber != null ? user.phoneNumber! : "",
                          style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        customLaunch('tel:${user.phoneNumber!}');
                      })
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
                child: Icon(Icons.navigation), onPressed: () {}),
          ),
        )
      ],
    );
  }
}
