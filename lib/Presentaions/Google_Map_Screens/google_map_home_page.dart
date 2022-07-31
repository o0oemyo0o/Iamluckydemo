import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/support_store_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
//
// class GoogleMapHomePage extends StatefulWidget {
//   final double lat;
//   final double lng;
//
//   const GoogleMapHomePage({Key? key, required this.lat, required this.lng})
//       : super(key: key);
//
//   @override
//   State<GoogleMapHomePage> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<GoogleMapHomePage> {
//   final Completer<GoogleMapController> _controller = Completer();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }

class GoogleMapHomePage extends StatefulWidget {
  final double lat;
  final double lng;

  const GoogleMapHomePage({Key? key, required this.lat, required this.lng})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapHomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  final _supportStoreController = Get.put(SupportStoreController());

  late BitmapDescriptor customIcon;
  late Set<Marker> markers;
  final Completer<BitmapDescriptor> bitmapIcon = Completer<BitmapDescriptor>();

  double selectedLat = 0.0;
  double selectedLng = 0.0;
  ValueNotifier<String> locationValue = ValueNotifier('');

  Placemark? placeMark;

  @override
  void initState() {
    super.initState();
    markers = <Marker>{};
  }

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(25, 25)),
        'assets/images/location.png')
        .then((d) {
      customIcon = d;
      setState(() {
        markers.add(Marker(
            markerId: const MarkerId('1'),
            position: LatLng(widget.lat, widget.lng),
            icon: customIcon));
      });
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: markers,
            onTap: (pos) async {
              Marker m = Marker(markerId: const MarkerId('2'), position: pos);
              markers.add(m);
              await _goToLocation(pos.latitude, pos.longitude);
              await convertToPlaceMark(pos.latitude, pos.longitude);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.lng), zoom: 14.0),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: SharedText.screenWidth,
              height: SharedText.screenHeight * 0.15,
              color: Colors.transparent,
              child: Row(
                children: [
                  SizedBox(width: SharedText.screenWidth * 0.025),
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20.0),
                      onPressed: () => Navigator.pop(context)),
                  Expanded(
                    child: Container(
                      height: getWidgetHeight(50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppConstants.roundedRadius)),
                      child: ValueListenableBuilder(
                        valueListenable: locationValue,
                        builder: (context, value, child) {
                          return Text(locationValue.value.toString(),
                              style: const TextStyle(color: Colors.black));
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: SharedText.screenWidth * 0.025),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToLocation(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, lng),
        tilt: 10,
        zoom: 14.0)));
  }

  Future<Placemark> convertToPlaceMark(
      double latitude, double longitude) async {
    var placeMarksList = await placemarkFromCoordinates(latitude, longitude);
    placeMark = placeMarksList.first;

    debugPrint('placeMarksList.first: ${placeMark!.street!} + '
        '${placeMark!.country!}');

    locationValue.value = placeMark!.street! + ', ' + placeMark!.country!;

    _supportStoreController.lat = latitude.toString();
    _supportStoreController.lng = longitude.toString();
    _supportStoreController.selectedPlaceMark.value = placeMark!;
    _supportStoreController.selectedLocationController.text =
        locationValue.value;

    debugPrint(
        'selectedPlaceMark.value: ${_supportStoreController.selectedPlaceMark.value.street!}');

    return placeMark!;
  }
}
