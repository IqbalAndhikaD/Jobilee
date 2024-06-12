// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tubes/navbar.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tubes/authentication/authen_service.dart';
import 'package:tubes/rsc/colors.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tubes/rsc/log.dart';

class GetMap extends StatefulWidget {
  final String job_id;
  const GetMap({super.key, required this.job_id});

  @override
  State<GetMap> createState() => _GetMapState();
}

class _GetMapState extends State<GetMap> {
  final user = AuthenService().currentUser;
  late GoogleMapController mapController;
  LatLng center = LatLng(-6.892696407681568, 107.61662993337156);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  dynamic userInfo;
  dynamic job;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getData();
  }

  Future<dynamic> getUserInfo() async {
    var result = await AuthenService().getUserInfo();
    if (result != null) {
      setState(() {
        userInfo = result;
      });
    }
  }

  Future<void> getData() async {
    DocumentReference<Map<String, dynamic>> jobVacation = FirebaseFirestore
        .instance
        .collection("job_vacations")
        .doc(widget.job_id);

    var result = await jobVacation.get();
    AppLog.info(result);

    final marker = Marker(
      markerId: MarkerId(result.data()!['company_name']),
      position: LatLng(result.data()!['location'].latitude,
          result.data()!['location'].longitude),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: result.data()!['company_name'],
        snippet: result.data()!['address'],
      ),
    );

    setState(() {
      if (result.data()!['location'] != null) {
        job = result;
        markers[MarkerId(result.data()!['company_name'])] = marker;
        center = LatLng(result.data()!['location'].latitude,
            result.data()!['location'].longitude);
      }
    });

    if (result.data()!['location'] != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(result.data()!['location'].latitude,
              result.data()!['location'].longitude),
          17.5));
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 5.0,
          ),
          markers: Set<Marker>.of(markers.values),
        ),
      ),
    );
  }
}
