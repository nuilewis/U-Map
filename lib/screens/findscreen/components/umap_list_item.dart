import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../size_config.dart';

class UmapListItem extends StatelessWidget {
  final String title;
  final String description;
  final String imgSrc;
  final String firstIconSvgLink;
  final String secondIconSvgLink;
  final VoidCallback firstIconOnPressed;
  final VoidCallback secondIconOnPressed;
  final LatLng sourceLocation;

  const UmapListItem({
    Key? key,
    required this.title,
    required this.description,
    required this.imgSrc,
    required this.firstIconSvgLink,
    required this.secondIconSvgLink,
    required this.sourceLocation,
    required this.firstIconOnPressed,
    required this.secondIconOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getRelativeScreenWidth(context, 20),
        vertical: getRelativeScreenHeight(context, 10),
      ),
      height: getRelativeScreenHeight(context, 180),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius:
            BorderRadius.circular(getRelativeScreenWidth(context, 32)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                  left: getRelativeScreenWidth(context, 20),
                  top: getRelativeScreenWidth(context, 15),
                  right: getRelativeScreenWidth(context, 10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        icon: SvgPicture.asset(
                          firstIconSvgLink,
                          color: Theme.of(context).iconTheme.color,
                          //color: Colors.black,
                        ),
                        onPressed: firstIconOnPressed,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          secondIconSvgLink,
                          color: Theme.of(context).iconTheme.color,
                          //color: Colors.black,
                        ),
                        onPressed: secondIconOnPressed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          ///Image container
          Expanded(
            flex: 1,
            child: Container(
              // height: getRelativeScreenHeight(context, 180),
              // width: getRelativeScreenHeight(context, 150),
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(imgSrc)),
                color: Theme.of(context).primaryColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(
                  getRelativeScreenWidth(context, 32),
                ),
                // image: DecorationImage(
                //   fit: BoxFit.fitHeight,
                //  // image: Image(image: NetworkImage(imgSrc!)),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
