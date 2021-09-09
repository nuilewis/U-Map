import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/screens/homescreen/components/umap_icon_button.dart';
import 'package:u_map/size_config.dart';

import 'components/location_details_description.dart';

class UmapLocationDetails extends StatefulWidget {
  final String name;
  final String description;
  final String? imgSrc;
  final LatLng markerLocation;

  const UmapLocationDetails(
      {Key? key,
      required this.name,
      required this.description,
      this.imgSrc,
      required this.markerLocation})
      : super(key: key);
  @override
  _UmapLocationDetailsState createState() => _UmapLocationDetailsState();
}

class _UmapLocationDetailsState extends State<UmapLocationDetails> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: getRelativeScreenHeight(context, 90),
        elevation: 0,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svg/back_icon.svg",
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: getRelativeScreenWidth(context, 15),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/svg/menu_icon.svg",
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getRelativeScreenHeight(context, 120)),
            // ///Top bar and menu
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: getRelativeScreenWidth(context, 20),
            //     vertical: getRelativeScreenHeight(context, 30),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       IconButton(
            //         icon: SvgPicture.asset(
            //           "assets/svg/back_icon.svg",
            //           color: Theme.of(context).iconTheme.color,
            //         ),
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //       ),
            //       IconButton(
            //         icon: SvgPicture.asset(
            //           "assets/svg/menu_icon.svg",
            //           color: Theme.of(context).iconTheme.color,
            //         ),
            //         onPressed: () {},
            //       ),
            //     ],
            //   ),
            // ),

            ///Picture container
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: getRelativeScreenWidth(context, 20),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .65,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  getRelativeScreenWidth(context, 32),
                ),
              ),
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 20),
            ),

            ///Buttons Section Below
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getRelativeScreenWidth(context, 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: getRelativeScreenWidth(context, 5),
                  ),

                  ///Distance Text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "1.3",
                            style: Theme.of(context).textTheme.headline1),
                        TextSpan(
                            text: " km",
                            style: Theme.of(context).textTheme.headline2),
                      ],
                    ),
                  ),

                  ///Add to  and remove from saved Button
                  UmapIconButton(
                    iconLink: "assets/svg/heart_icon.svg",
                    onPressed: () {},
                    bgColor: Theme.of(context).primaryColorLight,
                  ),

                  ///Get Directions Button
                  Container(
                    height: getRelativeScreenWidth(context, 60),
                    width: getRelativeScreenWidth(context, 150),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(
                        getRelativeScreenWidth(context, 20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Get Directions",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(
                          width: getRelativeScreenWidth(context, 5),
                        ),
                        SvgPicture.asset(
                          "assets/svg/direction_icon.svg",
                          color: Theme.of(context).iconTheme.color,
                          //height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: getRelativeScreenHeight(context, 20),
            ),

            ///Description Section
            LocDetailsDescriptionSection(
              name: widget.name,
              description: widget.description,
            ),
          ],
        ),
      ),
    );
  }
}
