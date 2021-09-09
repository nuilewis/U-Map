import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/screens/homescreen/components/umap_icon_button.dart';
import 'package:u_map/screens/homescreen/components/umap_top_search_area.dart';
import 'package:u_map/size_config.dart';

import 'components/location_details_description.dart';

class UmapLocationDetails extends StatefulWidget {
  @override
  _UmapLocationDetailsState createState() => _UmapLocationDetailsState();
}

class _UmapLocationDetailsState extends State<UmapLocationDetails> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: SvgPicture.asset(
      //       "assets/svg/back_icon.svg",
      //       color: Theme.of(context).iconTheme.color,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: SvgPicture.asset(
      //         "assets/svg/menu_icon.svg",
      //         color: Theme.of(context).iconTheme.color,
      //       ),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Top bar and menu
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getRelativeScreenWidth(context, 20),
                  vertical: getRelativeScreenHeight(context, 30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/svg/back_icon.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/svg/menu_icon.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

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
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: getRelativeScreenWidth(context, 20)),
              //   child: Container(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "The Central Adiministration",
              //           style: Theme.of(context).textTheme.headline2,
              //           textAlign: TextAlign.left,
              //         ),
              //         Divider(
              //           color: Theme.of(context).primaryColorLight,
              //           thickness: getRelativeScreenHeight(context, 5),
              //           endIndent: MediaQuery.of(context).size.width * .7,
              //         ),
              //         SizedBox(
              //           height: getRelativeScreenHeight(context, 15),
              //         ),
              //         Text(
              //             "The Central Admin description, tka;lja;a;aja, avjakja ahusvh asuhfa fasfharhf ahefsjdha hadhfauhfa;lh ahsdfhapug aghapoghahg aoghahjhfaP AGHAORHGA AOGIHA GHAHA;Hhs;ho AHAHAOHA al;agh aihaoh"),
              //         SizedBox(height: getRelativeScreenHeight(context, 30)),
              //       ],
              //     ),
              //   ),
              // ),
              LocDetailsDescriptionSection(
                name: "The Central Adiministration",
                description: ""
                    "The Central Admin description, tka;lja;a;aja, avjakja ahusvh asuhfa fasfharhf ahefsjdha hadhfauhfa;lh ahsdfhapug aghapoghahg"
                    " aoghahjhfaP AGHAORHGA AOGIHA"
                    " GHAHA;Hhs;ho AHA"
                    "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
