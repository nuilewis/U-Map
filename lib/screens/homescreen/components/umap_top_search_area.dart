import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/size_config.dart';

import 'umap_searchbar.dart';

class UmapTopSearchMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        getRelativeScreenWidth(context, 20),
        getRelativeScreenHeight(context, 60),
        getRelativeScreenWidth(context, 15),
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          UMapSearchBar(),
          SizedBox(
            width: getRelativeScreenWidth(context, 20),
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/svg/menu_icon.svg",
              color: Theme.of(context).iconTheme.color,
              //color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
