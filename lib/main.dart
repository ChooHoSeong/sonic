import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';


//DB PACK
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test2233/MyDrawer.dart';

import 'LoginScreen.dart';
import 'LogOutButton.dart';
import 'MyDrawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '위치 정보',
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng currentPosition = _kGooglePlex.target;

  final Completer<GoogleMapController> MapController =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }



  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {
      await Permission.locationWhenInUse.request();
    }
    moveCameraToPosition(await getCurrentPosition(),15);
  }

  void playSound() async {
    print("sound");
    final player = AudioPlayer();
    // await player.setSourceAsset('assets/audio/click.mp3');
    await player.setSource(AssetSource('audio/click.mp3'));
    await player.play(AssetSource('audio/click.mp3'));
  }

  Marker? userLocationMarker;
  Set<Marker> markers = {};

  Future<void> updateMarkersFromFirebase() async {
    // Fetch 'user' collection from Firestore
    var users = FirebaseFirestore.instance.collection('user');

    // Retrieve all documents
    var snapshot = await users.get();

    // Clear old markers
    setState(() {
      markers.clear();
    });

    // Go through all documents
    for (var user in snapshot.docs) {
      // Check if 'position' and 'color' fields exist
      if (user.data().containsKey('position') && user.data().containsKey('color')) {
        GeoPoint position = user.data()['position'];
        double color = (user.data()['color'] as num).toDouble();

        // Create a new LatLng object
        LatLng userPosition = LatLng(position.latitude, position.longitude);

        // Create a new marker
        Marker marker = Marker(
          markerId: MarkerId(user.id), // Use document ID as marker ID
          position: userPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(color),
        );

        // Add marker to the set
        setState(() {
          markers.add(marker);
        });
      }
    }
  }
  Future<LatLng> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  Future<void> moveCameraToPosition(LatLng position,double z) async {
    final GoogleMapController controller = await MapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: z,
      ),
    ));
  }

  Future<void> updateUserPositionInFirebase() async {
    final _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final userUid = currentUser.uid;
      final currentPosition = await getCurrentPosition();
      final geoPoint = GeoPoint(currentPosition.latitude, currentPosition.longitude);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .update({
        'position': geoPoint,
        'time':Timestamp.now()
      });
    }
  }

  // (the rest of the methods, including `updateMarkersFromFirebase`, stay the same)

  Future<void> handleButtonClick() async {
    moveCameraToPosition(await getCurrentPosition(), 14.5);
    playSound();

    updateUserPositionInFirebase();
    updateMarkersFromFirebase();
    Future.delayed(Duration(seconds: 1), () async {
      moveCameraToPosition(await getCurrentPosition(), 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return LogOut();
                }
                return Text('Copyright ⓒ 2023 by ChooHoSeong');
              }
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        width: 260,
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('user').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final Docs = snapshot.data!.docs;

              return ListView.builder(
                  padding: EdgeInsets.only(top: 80,left: 0,right: 0,bottom: 0),
                  // reverse: true,
                  itemCount: Docs.length,
                  itemBuilder: (context, index){
                    print('sdfsdfsfd${Docs[index]['userName']}');
                    return MyDrawer(Docs[index]['userName'],Docs[index]['color'],Docs[index]['time'].toDate());
                  }
              );
              // return MyDrawer(Docs['userName'],Docs['color']);
            }
        ),
      ),
      body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                MapController.complete(controller);
              },
              markers: markers,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - 85,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: handleButtonClick,//clickAction
                    child: Container(
                      width: 60,
                      height: 60,

                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.purple
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(0,0),
                            )
                          ]
                      ),
                      child: const Icon(
                        Icons.wifi_tethering, color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container();
                  }
                  return LoginScreen();
                }
            )
          ]
      ),
    );
  }
}


