import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:u_map/size_config.dart';

class PopularPlacesListItem extends StatelessWidget {
  final String title;
  final String? imageSrc;
  final GeoPoint markerGeopoint;
  final VoidCallback? onPressed;

  const PopularPlacesListItem(
      {Key? key,
      required this.title,
      required this.markerGeopoint,
      this.imageSrc,
      this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Popular place list item
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
            left: getRelativeScreenWidth(context, 20), right: 0),
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
        child: Padding(
          padding:
              EdgeInsets.only(bottom: getRelativeScreenHeight(context, 20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
