import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:u_map/size_config.dart';

class UMapSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: getRelativeScreenWidth(250),
      height: getRelativeScreenHeight(60),
      padding: EdgeInsets.only(
        top: getRelativeScreenWidth(2),
        left: getRelativeScreenWidth(15),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(
          getRelativeScreenWidth(15),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
            suffixIcon: IconButton(
              splashColor: Colors.transparent,
              icon: SvgPicture.asset(
                "assets/svg/search_icon.svg",
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {},
            ),
            hintText: "Search",
            //hintTextDirection: TextDirection.rtl,
            border: InputBorder.none),
        //textDirection: TextDirection.rtl,
      ),
    );
  }
}
