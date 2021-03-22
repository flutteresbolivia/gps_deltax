import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_1_22_6/widgets/reset_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_1_22_6/widgets/bottom_view.dart';
import 'package:google_maps_1_22_6/widgets/centered_marker.dart';
import 'package:google_maps_1_22_6/providers/local_notifications_providers.dart';
import 'package:google_maps_1_22_6/widgets/my_location_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/pages/home/bloc.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final HomeBloc _bloc = HomeBloc();
  bool _fromSettings = false;

  // -0.1081339,-78.4699519,18z

  final LocalNotificationsProvider localNotificationsProviders =
      new LocalNotificationsProvider();
  LatLng _at;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _bloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("AppLifecycleState::::: $state ");

    final isEnabled = await Geolocator.isLocationServiceEnabled();
    print('is enanled  did${isEnabled}');
    if (!isEnabled  && state == AppLifecycleState.resumed) {
      return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Container(
                alignment: Alignment.center,
                child: Text('asdasda'
                    //style: TextStyle(color: primaryColor),
                    ),
              ),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.gps_off,
                          color: Colors.orange,
                          size: 32,
                        ),
                        SizedBox(width: 50),
                        Icon(
                          Icons.settings,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'StringsApp.msg_permisions_geolocation_disabled',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // actionsOverflowButtonSpacing: 20,
              // actionsOverflowDirection: VerticalDirection.up,
              actions: <Widget>[
                FlatButton(
                  child: Text("cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("ok"),
                  onPressed: () async {
                    await AppSettings.openLocationSettings();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomHeight = MediaQuery.of(context).padding.bottom;
    return BlocProvider.value(
      value: this._bloc,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          onPressed: () async {
            var status = await Permission.notification.isUndetermined;
            AppSettings.openNotificationSettings();
            print(status);
            await localNotificationsProviders.init();
            await localNotificationsProviders.showNotification();
          },
        ),
        body: SlidingUpPanel(
          panel: BottomView(),
          minHeight: 100 + bottomHeight,
          body: SafeArea(
            bottom: false,
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                final isEnabled = await Geolocator.isLocationServiceEnabled();
                print('is enanled ${isEnabled}');
                if (!state.gpsEnabled) {
                  return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding:
                              EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          title: Container(
                            alignment: Alignment.center,
                            child: Text('asdasda'
                                //style: TextStyle(color: primaryColor),
                                ),
                          ),
                          content: Container(
                            height: 120,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.gps_off,
                                      color: Colors.orange,
                                      size: 32,
                                    ),
                                    SizedBox(width: 50),
                                    Icon(
                                      Icons.settings,
                                      color: Colors.orange,
                                      size: 32,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'StringsApp.msg_permisions_geolocation_disabled',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // actionsOverflowButtonSpacing: 20,
                          // actionsOverflowDirection: VerticalDirection.up,
                          actions: <Widget>[
                            FlatButton(
                              child: Text("cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("ok"),
                              onPressed: () async {
                                await AppSettings.openLocationSettings();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }
              },
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (_, state) {
                  if (!state.gpsEnabled) {
                    return Center(
                      child: Text(
                        "Para utilizar la app active el GPS",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (state.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  final CameraPosition initialPosition = CameraPosition(
                    target: state.myLocation,
                    zoom: 15,
                  );

                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            GoogleMap(
                              initialCameraPosition: initialPosition,
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                              myLocationEnabled: true,
                              onCameraMoveStarted: () {
                                print("onCameraMoveStarted");
                                if (state.mapPick != MapPick.none) {
                                  this._bloc.onCameraMoveStarted();
                                }
                              },
                              onCameraMove: (cameraPosition) {
                                this._at = cameraPosition.target;
                              },
                              onCameraIdle: () {
                                if (state.mapPick != MapPick.none) {
                                  this._bloc.reverseGeocode(this._at);
                                }
                              },
                              markers: state.markers.values.toSet(),
                              polylines: state.polylines.values.toSet(),
                              polygons: state.polygons.values.toSet(),
                              myLocationButtonEnabled: false,
                              onMapCreated: (GoogleMapController controller) {
                                this._bloc.setMapController(controller);
                              },
                            ),
                            MyLocationButton(),
                            CenteredMarked(),
                            ResetButton()
                          ],
                        ),
                      ),
                      SizedBox(height: 100 + bottomHeight),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
