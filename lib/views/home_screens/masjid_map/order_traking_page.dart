import 'dart:async';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/qibla_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng destination =
      LatLng(29.504977, -95.762822); // Masjid location
  List<LatLng> polylineCoordinates = [];
  final Set<Polyline> _polylines = {};
  LatLng? currentLocation;
  late Location location;

  @override
  void initState() {
    super.initState();
    location = Location();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Listen to location changes if you want continuous updates
    location.onLocationChanged.listen((LocationData _locationData) {
      setState(() {
        currentLocation =
            LatLng(_locationData.latitude!, _locationData.longitude!);
      });
      _updatePolyline();
      _animateToUserLocation();
    });
  }

  Future<void> _updatePolyline() async {
    if (currentLocation == null) return;

    polylineCoordinates = [
      currentLocation!,
      destination,
    ];

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  Future<void> _animateToUserLocation() async {
    if (currentLocation == null) return;
    final GoogleMapController controller = await _controller.future;

    // Animate the camera to show both current location and destination
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            currentLocation!.latitude < destination.latitude
                ? currentLocation!.latitude
                : destination.latitude,
            currentLocation!.longitude < destination.longitude
                ? currentLocation!.longitude
                : destination.longitude,
          ),
          northeast: LatLng(
            currentLocation!.latitude > destination.latitude
                ? currentLocation!.latitude
                : destination.latitude,
            currentLocation!.longitude > destination.longitude
                ? currentLocation!.longitude
                : destination.longitude,
          ),
        ),
        50.0,
      ),
    );
  }

  // Function to launch Google Maps for navigation
  Future<void> _launchGoogleMaps() async {
    if (currentLocation == null) return;

    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${currentLocation!.latitude},${currentLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    var qiblaController = Get.put(QiblahController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "Direction to RCC",
          style: TextStyle(
            color: Colors.white,
            fontFamily: popinsSemiBold,
            fontSize: 20,
            // fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLocation!,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('sourceLocation'),
                      position: currentLocation!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure,
                      ),
                    ),
                    const Marker(
                      markerId: MarkerId(
                        'destination',
                      ),
                      position: destination,
                    ),
                  },
                  polylines: _polylines,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Current Location",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: popinsSemiBold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "${qiblaController.locationCountry}, ${qiblaController.locationCity}",
                                style: TextStyle(
                                  fontSize: 16, fontFamily: popinsRegulr,
                                  // fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.location_on,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchGoogleMaps,
        label: const Text("Navigate"),
        icon: const Icon(Icons.navigation),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
