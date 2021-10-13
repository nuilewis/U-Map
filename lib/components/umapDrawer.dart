import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UmapDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: [
          SvgPicture.asset("assetName"),
          ListTile(
            selected: true,
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            selected: true,
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "About",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            selected: true,
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "Favourites",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            selected: true,
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "Find",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            selected: true,
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "Dark Mode",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            onTap: () {},
            selected: true,
            enableFeedback: true,
            selectedTileColor: Theme.of(context).primaryColor,
            title: Text(
              "Privacy Policy",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
