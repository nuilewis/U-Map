import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:u_map/components/umap_location/umap_permissions.dart';
import 'package:u_map/screens/homescreen/components/umap_maps.dart';
import 'package:u_map/screens/homescreen/components/umap_top_search_area.dart';
import 'package:u_map/screens/permissionscreens/umapPermissionScreen.dart';
import 'package:u_map/size_config.dart';
import 'components/umap_popular_places.dart';

class UMapHomeScreen extends StatefulWidget {
  @override
  _UMapHomeScreenState createState() => _UMapHomeScreenState();
}

class _UMapHomeScreenState extends State<UMapHomeScreen> {
  void initState() {
    super.initState();
    checkPermissionStatus();
    checkServiceEnabled();
  }

  ///Check in Permissions aE granted
  Future<void> checkPermissionStatus() async {
    PermissionStatus? currentPermissionStatus = await getPermissionStatus();

    if (currentPermissionStatus != PermissionStatus.granted) {
      Future.delayed(Duration(seconds: 5), () async {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => UmapPermissionsScreen(
                title: "Let us use your Location?",
                message:
                    "We need permission to access your location for certain features to work properly",
                buttonText: "Lets do this!",
                onPressed: () {
                  Feedback.forTap(context);
                  HapticFeedback.lightImpact();
                  Navigator.pop(context, requestPermissions());
                },
              ),
            ),
          );
        });
      });
    }
  }

  ///Check in Permissions aE granted
  Future<void> checkServiceEnabled() async {
    PermissionStatus? currentPermissionStatus = await getPermissionStatus();

    if (currentPermissionStatus != PermissionStatus.granted) {
      Future.delayed(Duration(seconds: 7), () async {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => UmapPermissionsScreen(
                title: "Ooops!, Your Location is off",
                message: "It seems your Location is turned off",
                buttonText: "Turn it on",
                onPressed: () {
                  Feedback.forTap(context);
                  HapticFeedback.lightImpact();
                  Navigator.pop(context, requestServiceEnabled());
                },
              ),
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.white70,
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: SvgPicture.asset(
      //         "assets/svg/menu_icon.svg",
      //         color: Theme.of(context).iconTheme.color,
      //       ),
      //       onPressed: () {},
      //       //color: Theme.of(context).iconTheme.color,
      //     ),
      //   ],
      // ),

      body: SafeArea(
        child: Stack(
          children: [
            UmapMaps(),
            UmapTopSearchMenu(),
            PopularPlaces(),
          ],
        ),
      ),
    );
  }
}
