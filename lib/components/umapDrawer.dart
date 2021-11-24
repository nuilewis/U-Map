import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/screens/savedscreen/umap_savedscreen.dart';
import 'package:u_map/size_config.dart';

class UmapDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(
          left: 10,
          top: getRelativeScreenHeight(context, 80),
        ),
        //shrinkWrap: true,
        children: [
          Container(
              child: SvgPicture.asset(
            "assets/svg/umap_logo.svg",
            height: 70,
          )),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/users_icon.svg",
              color: Theme.of(context).iconTheme.color,
            ),
            //onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => UMapAboutScreen()));},
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "About",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/dark_mode_icon.svg",
              color: Theme.of(context).iconTheme.color,
            ),
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "Dark Mode",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          // ListTile(
          //   leading: SvgPicture.asset(
          //     "assets/svg/heart_icon.svg",
          //     color: Theme.of(context).iconTheme.color,
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => UMapSavedScreen()));
          //   },
          //   enableFeedback: true,
          //   selectedTileColor: Theme.of(context).primaryColor,
          //   title: Text(
          //     "Privacy Policy",
          //     style: Theme.of(context).textTheme.bodyText1,
          //   ),
          // ),
        ],
      ),
    );
  }
}
