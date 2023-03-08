import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'dart:async';
import '../../../Data/provider/attendance_provider.dart';

class AttendanceLocationMap extends StatefulWidget {
  const AttendanceLocationMap({Key? key}) : super(key: key);

  @override
  State<AttendanceLocationMap> createState() => _AttendanceLocationMapState();
}

class _AttendanceLocationMapState extends State<AttendanceLocationMap> {
  String location = "Search Location".tr();
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;

  var selectedLatLang = null;
  bool selected = false;
  bool done = false;
  double lat = 0.0;
  double lang = 0.0;
  String googleApikey = AppConstants.GOOGLE_API_KEY;

  initPlatformState() async {
    var status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {
    finish(context);
  } else {
    await Provider.of<AccountProvider>(context, listen: false).setCurrentLocation(context);
    done = true;
    if (!selected && done) {
      lat = double.parse(await Provider.of<AttendanceProvider>(context, listen: false).attendanceRepo.getLatitude());
      lang = double.parse(await Provider.of<AttendanceProvider>(context, listen: false).attendanceRepo.getLongitude());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> _disposeController() async {
    await mapController;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, child) {

      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
            'Location Map'.tr(),
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(children: [
          GoogleMap(
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: LatLng(lat, lang), //initial position
              zoom: 14.0, //initial zoom level
            ),
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona;
            },
            onCameraIdle: () async {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition!.target.latitude,
                  cameraPosition!.target.longitude);
              setState(() {
                location = placemarks.first.administrativeArea.toString() +
                    ", " +
                    placemarks.first.street.toString();
              });
            },
          ),
          Center(
            //picker image on google map
            child: Image.asset(
              "assets/images/picker.png",
              width: 80,
            ),
          ),
          Positioned(
            //search input bar
            top: 30,
            child: InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    language: 'Ar',
                    strictbounds: false,
                    components: [Component(Component.country, 'SA')],
                    //google_map_webservice package
                    onError: (err) {
                      print(err);
                    });

                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                  });

                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(
                    apiKey: googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  lat = geometry.location.lat;
                  lang = geometry.location.lng;
                  selectedLatLang = LatLng(lat, lang);
                  selected = true;

                  //move map camera to selected place with animation
                  mapController?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: selectedLatLang, zoom: 17)));
                }
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        title: Text(
                          location,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.search),
                        dense: true,
                      )),
                ),
              ),
            ),
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            attendanceProvider.setLatLang(context, lat, lang);
          },
          label: Text("Confirm".tr()),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      );
    });
  }
}
