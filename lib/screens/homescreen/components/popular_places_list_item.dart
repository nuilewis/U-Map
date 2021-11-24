import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:u_map/size_config.dart';

class PopularPlacesListItem extends StatelessWidget {
  final String title;
  final String saveIconLink;
  final String imageSrc;
  final GeoPoint? markerGeopoint;
  final VoidCallback? onPressed;
  final VoidCallback? onSavedPressed;

  const PopularPlacesListItem(
      {Key? key,
      required this.title,
      required this.saveIconLink,
      this.markerGeopoint,
      required this.imageSrc,
      this.onPressed,
      this.onSavedPressed})
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
        height: getRelativeScreenWidth(context, 240),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(
            getRelativeScreenWidth(context, 30),
          ),
        ),
        child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
          //Image container
          Container(
            width: getRelativeScreenWidth(context, 150),
            height: getRelativeScreenWidth(context, 240),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(getRelativeScreenWidth(context, 30)),
              child: CachedNetworkImage(
                  fadeOutDuration: const Duration(milliseconds: 250),
                  fadeInDuration: const Duration(milliseconds: 250),
                  fadeInCurve: Curves.easeOut,
                  fadeOutCurve: Curves.easeOut,
                  fit: BoxFit.cover,
                  imageUrl: imageSrc,
                  placeholder: (context, imageSrc) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).iconTheme.color!),
                      ),
                    );
                  }),
            ),
          ),
          //Black Blur Container
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(getRelativeScreenWidth(context, 30)),
              gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(.7), Colors.transparent],
                  stops: [0.1, 0.4],
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter),
            ),
          ),
          //Text and Save Icon
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
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
                    icon: SvgPicture.asset(saveIconLink,
                        height: 18, color: Colors.white),
                    onPressed: onSavedPressed,
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
