import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Stations/controller/StationListController.dart';
import '../../Stations/models/StationListResponse.dart';
import 'dart:ui' as ui;

class MapPageView extends StatefulWidget {
  const MapPageView({Key? key}) : super(key: key);

  @override
  State<MapPageView> createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  GoogleMapController? _controller;
  late StationListResponse stationListResponse;
  bool stationListLoaded = false;
  bool selectedStation = false;
  String selectedPowerStationid = '';
  late StationModel selectedStationModel;
  late BitmapDescriptor customIcon;
  late BitmapDescriptor customIconSelected;
  Set<Marker> customMarkers = Set<Marker>();
  final location.Location _location = location.Location();
  String latitude = '';
  String longitude = '';
  bool firstZoom = true;
  final LatLng _initialcameraposition = const LatLng(20.5937, 78.9629);
  ColorUtil colorUtil = ColorUtil();
  List filterList = [
    {
      "name": "Car Wash",
      "image": "assets/images/Car Wash@3x.png",
      "selected": false,
    }
  ];
  String mapStyle = '''[
    {
      "elementType": "geometry",
      "stylers": [
        {"color": "#fbfbfb"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {"color": "#ffffff"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {"color": "#F1F1F3"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#B1B1BB"}
      ]
    }
  ]''';

  @override
  void initState() {
    super.initState();
    setMarker();
  }

  setMarker() {
    getBytesFromAsset('assets/images/Station Unselected@3x.png', 75).then((onValue) {
      customIcon = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset('assets/images/Station Selected@3x.png', 75).then((onValue) {
      customIconSelected = BitmapDescriptor.fromBytes(onValue);
    });
    // BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(devicePixelRatio: 2.0, size: Size(10, 10)),
    //   'assets/images/Station Unselected@3x.png',
    // ).then((d) {
    //   //debugPrint("custom icon : $d");
    //   setState(() {
    //     customIcon =d;
    //   });
    // });
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    _controller = _cntlr;
    _cntlr.setMapStyle(mapStyle);
    getStationsList();
    // showBottomSheet();

    await _location.requestPermission();
    if (!await _location.serviceEnabled()) {
      await _location.requestService();
    }
    // await _location.getLocation().then((l) {
    //   _controller?.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         target: LatLng(l.latitude!, l.longitude!),
    //         zoom: 8.0,
    //       ),
    //     ),
    //   );
    //   latitude = l.latitude.toString();
    //   longitude = l.longitude.toString();
    //   // getStationsList();
    //   setState(() {});
    //   //debugPrint("Latitude : $latitude");
    //   //debugPrint("Longitude : $longitude");
    // });
  }

  getStationsList() async {
    stationListResponse = await StationListController().getStationList();

    setState(() {
      // debugPrint(stationListResponse.stationList.toString());
      stationListLoaded = true;
    });
    mapBitmapsToMarkers(stationListResponse.stationList);
  }

  mapBitmapsToMarkers(List<StationModel> stationList) async {
    customMarkers.clear();
    for (StationModel powerStation in stationList) {
      //debugPrint(powerStation.latitude.toString());
      try {
        double lat = double.parse(powerStation.latitude);
        double lng = double.parse(powerStation.longitude);
        customMarkers.add(
          Marker(
            markerId: MarkerId(powerStation.id.toString()),
            position: LatLng(lat, lng),
            icon: selectedPowerStationid == powerStation.id.toString()
                ? customIconSelected
                : customIcon,
            onTap: () {
              //debugPrint("Marker tapped");
              if (selectedStation && selectedPowerStationid == powerStation.id.toString()) {
                selectedStation = false;
                selectedPowerStationid = '';

                setState(() {});
              } else {
                selectedStation = true;
                selectedPowerStationid = powerStation.id.toString();
                selectedStationModel = powerStation;
                setState(() {});
              }
              mapBitmapsToMarkers(stationList);

              // showBottomSheet();
            },
            // icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: powerStation.name,
              snippet: powerStation.contact_no,
            ),
          ),
        );
      } catch (e) {
        //debugPrint(e.toString());
      }
    }
    // //debugPrint(stationList.length);
    // //debugPrint(customMarkers.length);
    // List<PowerStation> tempNearByPowerStations = [];
    // for (PowerStation powerStation in powerStations) {
    //   if (powerStation.distance < 50) {
    //     tempNearByPowerStations.add(powerStation);
    //   }
    // }

// un comment this to show markers on map
    setState(() {});

    if (stationListResponse.stationList.length > 0 && firstZoom) {
      int randIndex = Random().nextInt(stationList.length - 1);

      double lat1 = double.parse(stationListResponse.stationList[randIndex].latitude);
      double lng1 = double.parse(stationListResponse.stationList[randIndex].longitude);
      // //debugPrint(lat1);
      // //debugPrint(lng1);
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat1, lng1),
            zoom: 8,
          ),
        ),
      );
      firstZoom = false;
    }

    setState(() {});
  }

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        elevation: 4,
        enableDrag: true,
        isDismissible: true,
        builder: (builder) {
          double mWidth = MediaQuery.of(context).size.width;
          double mHeight = MediaQuery.of(context).size.height;
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
              builder: (context, StateSetter setChooseCategoryState) => Container(
                width: mWidth,
                height: mHeight * 0.40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                        child: Container(
                          height: 4,
                          width: 52,
                          padding: const EdgeInsets.fromLTRB(4, 10, 4, 20),
                          decoration: const BoxDecoration(
                              color: Color(0x333c3c43),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xffE8E8E8).withOpacity(0.5)),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 40,
                                padding: EdgeInsets.only(left: 15, right: 8),
                                child: Image.asset(
                                  "assets/images/Search2@3x.png",
                                )),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontFamily: "Sofia"),
                                    border: InputBorder.none,
                                    hintText: "Search"),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        child: ListView.builder(
                          itemCount: filterList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xffFFEFEE),
                                  border: Border.all(color: Color(0xffFFDAD8), width: 1),
                                ),
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(children: [
                                  Image.asset(filterList[index]['image']),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(filterList[index]['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff3C3C3C))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                            child: Text(
                              "Fuel Prices",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3C3C3C)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Color(0xffFFffff),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff000000).withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                          border: Border.all(color: Color(0xff000000).withOpacity(0.1), width: 1),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(
                            children: [
                              Text("340 Bz",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000))),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Diesel",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtil().primaryRed)),
                            ],
                          ),
                          Column(
                            children: [
                              Text("239 Bz",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff3C3C3C))),
                              SizedBox(
                                height: 5,
                              ),
                              Text("M95",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtil().primaryRed)),
                            ],
                          ),
                          Column(
                            children: [
                              Text("229 Bz",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff3C3C3C))),
                              SizedBox(
                                height: 5,
                              ),
                              Text("M91",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtil().primaryRed)),
                            ],
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _currentLocation() async {
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      _controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0),
          zoom: 8.0,
        ),
      ));
    } on Exception {}
  }

  void _launchMapsUrl(String lat, String long) async {
    final query = '$lat,$long(Power Station)';
    final uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xffFFFFFF),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              compassEnabled: false,
              // scrollGesturesEnabled: false,
              // tiltGesturesEnabled: false,
              myLocationEnabled: true,

              myLocationButtonEnabled: false,
              buildingsEnabled: true,
              indoorViewEnabled: true,

              zoomControlsEnabled: false,
              // zoomGesturesEnabled: false,
              mapToolbarEnabled: false,
              // rotateGesturesEnabled: false,
              markers: customMarkers,
              // liteModeEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: _initialcameraposition, zoom: 8),

              // markers: Set.from(controller.allMarkers),
              onMapCreated: _onMapCreated,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 28.0, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff000000).withOpacity(0.1),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1),
                                  ),
                                ]),
                            child: IconButton(
                                onPressed: showBottomSheet,
                                tooltip: 'Open sheet',
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.keyboard_double_arrow_up_rounded,
                                  color: Colors.black,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff000000).withOpacity(0.1),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1),
                                  ),
                                ]),
                            child: IconButton(
                                onPressed: _currentLocation,
                                tooltip: 'My Location',
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.gps_fixed_rounded,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                selectedStation && selectedPowerStationid != ''
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: GestureDetector(
                          onTap: () {
                            double lat = double.parse(selectedStationModel.latitude);
                            double lng = double.parse(selectedStationModel.longitude);
                            _controller?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(lat, lng),
                                  zoom: 8,
                                ),
                              ),
                            );
                          },
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: colorUtil.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(selectedStationModel.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff000000))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Image.asset(
                                            "assets/images/Location3@3x.png",
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                        Text(selectedStationModel.region,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: ColorUtil().primaryRed)),
                                      ],
                                    ),
                                    Divider(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        getServicesWidget(selectedStationModel),
                                        GestureDetector(
                                          onTap: () {
                                            _launchMapsUrl(selectedStationModel.latitude,
                                                selectedStationModel.longitude);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: colorUtil.primaryRed),
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                              child: Row(
                                                children: [
                                                  Image.asset('assets/images/Navigate@3x.png',
                                                      height: 22, width: 22),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text("Navigate",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: colorUtil.white)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  Row getServicesWidget(StationModel selectedStationModel) {
    int servicesCount = 0;
    List<Widget> servicesWidget = [];
    if (selectedStationModel.carWash != "null" && selectedStationModel.carWash == "true") {
      servicesCount++;
      servicesWidget.add(Image.asset('assets/images/Car Washing@3x.png', height: 24, width: 24));
    }
    // if (selectedStationModel.cstore != "null" && selectedStationModel.cstore == "true") {
    //   servicesCount++;
    //   servicesWidget.add(Image.asset('assets/images/car service@3x.png', height: 24, width: 24));
    // }
    if (selectedStationModel.atm != "null" && selectedStationModel.atm == "true") {
      servicesCount++;
      servicesWidget.add(Image.asset('assets/images/car service@3x.png', height: 24, width: 24));
    }
    // if (selectedStationModel.fuelM98 != "null" && selectedStationModel.fuelM98 == "true") {
    //   servicesCount++;
    //   servicesWidget.add(Image.asset('assets/images/Car Transfer@3x.png', height: 24, width: 24));
    // }
    if (selectedStationModel.repairWorkshop != "null" &&
        selectedStationModel.repairWorkshop == "true") {
      servicesCount++;
      servicesWidget.add(Image.asset('assets/images/Car Transfer@3x.png', height: 24, width: 24));
    }
    return Row(
      children: [
        ...servicesWidget,
        (servicesCount > 3)
            ? Text("+${servicesCount - 3} More",
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: ColorUtil().primaryRed))
            : Container()
      ],
    );
  }
}
