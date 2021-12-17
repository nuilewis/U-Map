import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/screens/searchscreen/umap_searchscreen.dart';
import 'package:u_map/size_config.dart';

import 'umap_searchbar.dart';

class UmapAppBar extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;

  UmapAppBar({
    this.preferredSize = const Size.fromHeight(80),
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      // leading: Padding(
      //   padding: const EdgeInsets.only(left: 20),
      //   child: SvgPicture.asset(
      //     "assets/svg/search_icon.svg",
      //     color: Theme.of(context).iconTheme.color,
      //   ),
      // ),
      // leading: Padding(
      //   padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      //   child: SvgPicture.asset(
      //     "assets/svg/umap_logo.svg",
      //     height: 90,
      //   ),
      // ),
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          icon: SvgPicture.asset(
            "assets/svg/search_icon.svg",
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UmapSearchScreen(),
              ),
            );
          },
        ),
        SizedBox(
          width: getRelativeScreenWidth(context, 10),
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/svg/menu_alt_icon.svg",
            color: Theme.of(context).iconTheme.color,
            //color: Colors.black,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
        SizedBox(
          width: getRelativeScreenWidth(context, 20),
        ),
      ],
    );
  }
}
