import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:u_map/size_config.dart';

class UMapSearchBar extends StatefulWidget {
  @override
  _UMapSearchBarState createState() => _UMapSearchBarState();
}

class _UMapSearchBarState extends State<UMapSearchBar> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: getRelativeScreenWidth(context, 250),
      height: getRelativeScreenHeight(context, 60),
      padding: EdgeInsets.only(
        top: getRelativeScreenWidth(context, 2),
        left: getRelativeScreenWidth(context, 15),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        //color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(
          getRelativeScreenWidth(context, 15),
        ),
        border: Border.all(
            color: Theme.of(context).primaryColorLight.withOpacity(.5)),
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
