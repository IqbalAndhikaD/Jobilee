// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jobilee/navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:jobilee/authentication/authen_service.dart';
import 'package:jobilee/rsc/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobilee/services/job_service.dart';
import 'package:jobilee/rsc/log.dart';

class GetMap extends StatefulWidget {
  final String job_vacation_id;
  const GetMap({super.key, required this.job_vacation_id});

  @override
  State<GetMap> createState() => _GetMapState();
}

class _GetMapState extends State<GetMap> {
  final user = AuthenService().currentUser;
  late MapController mapController;
  LatLng center = const LatLng(-6.892696407681568, 107.61662993337156);
  List<Marker> markers = [];
  dynamic userInfo;
  dynamic job;
  String companyNameVal = '';
  String addressVal = '';

  Future<dynamic> getUserInfo() async {
    var result = await AuthenService().getUserInfo();
    if (result != null) {
      setState(() {
        userInfo = result;
      });
    }
  }

  Future<void> getData() async {
    final result = await JobService.getJobById(widget.job_vacation_id);
    AppLog.info(result);

    if (result == null) return;

    final lat = (result['latitude'] as num?)?.toDouble();
    final lng = (result['longitude'] as num?)?.toDouble();

    if (lat == null || lng == null) return;

    final marker = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lng),
      child: const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40.0,
      ),
    );

    setState(() {
      companyNameVal = result['company'] ?? '';
      addressVal = result['location'] ?? '';
      job = result;
      markers = [marker];
      center = LatLng(lat, lng);
    });

    mapController.move(LatLng(lat, lng), 17.5);
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    getUserInfo();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Wrap(
          children: [
            Text("$companyNameVal Location"),
            Text(
              addressVal,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 5.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.tubes.jobilee',
            ),
            MarkerLayer(
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }
}
