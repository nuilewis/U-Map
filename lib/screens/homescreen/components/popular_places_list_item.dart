import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:u_map/size_config.dart';

class PopularPlacesListItem extends StatelessWidget {
  final String title;
  final String? imageSrc;

  const PopularPlacesListItem({Key? key, required this.title, this.imageSrc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Popular place list item
    return Container(
      margin:
          EdgeInsets.only(left: getRelativeScreenWidth(context, 20), right: 0),
      width: getRelativeScreenWidth(context, 150),
      height: getRelativeScreenHeight(context, 240),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(
          getRelativeScreenWidth(context, 30),
        ),
        //   image: DecorationImage(
        //     image: NetworkImage(imagesrc),
        //   ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: getRelativeScreenHeight(context, 15),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  iconSize: 12,
                  splashColor: Colors.transparent,
                  icon: SvgPicture.asset(
                    "assets/svg/heart_icon.svg",
                    height: 18,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
