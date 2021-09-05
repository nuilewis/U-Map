import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/screens/homescreen/components/popular_places_list_item.dart';
import 'package:u_map/size_config.dart';

class PopularPlaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    ///Draggable Scrollable Sheet
    return DraggableScrollableSheet(
      maxChildSize: .6,
      minChildSize: .2,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(getRelativeScreenWidth(32)),
                  bottom: Radius.zero),
            ),

            //color: Colors.white,
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * .55,
            child: Stack(
              children: [
                ///Draggable icon indicator
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: getRelativeScreenHeight(5),
                      width: getRelativeScreenWidth(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Popular Places Text
                    Padding(
                      padding: EdgeInsets.only(
                        top: getRelativeScreenHeight(30),
                        left: getRelativeScreenWidth(20),
                      ),
                      child: Text(
                        "Popular Places",
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: getRelativeScreenHeight(30),
                    ),

                    // ListView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: 5,
                    //   itemBuilder: (context, index) {
                    //     return PopularPlacesListItem(
                    //       title: "The Central \n Administration",
                    //     );
                    //   },
                    // ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PopularPlacesListItem(
                            title: "The Central \n Administration",
                          ),
                          PopularPlacesListItem(
                            title: "The Central \n Administration",
                          ),
                          PopularPlacesListItem(
                            title: "The Central \n Administration",
                          ),
                          PopularPlacesListItem(
                            title: "The Central \n Administration",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget BuildPopularPlacesList(index, Document) {
  //   return PopularPlacesListItem(title: 'hey guys');
  // }
}
