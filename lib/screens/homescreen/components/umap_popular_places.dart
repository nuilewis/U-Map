import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/screens/homescreen/components/popular_places_list_item.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/size_config.dart';

class PopularPlaces extends StatelessWidget {
  final Stream<QuerySnapshot> umapFirestoreStream =
      FirebaseFirestore.instance.collection('umap_uba').snapshots();
  late final LatLng markerLoc;

  Widget buildPopularPlacesList(
      BuildContext context, DocumentSnapshot document) {
    ///Todo: Add code to find the most popular locations
    return PopularPlacesListItem(
      title: document["name"],
      markerGeopoint: document["location"],
      imageSrc: null,
      onPressed: () {
        markerLoc = LatLng(
            document["location"].latitude, document["location"].longitude);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              name: document["name"],
              description: document["description"],
              markerLocation: markerLoc,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    //SizeConfig().init(context);

    ///Draggable Scrollable Sheet
    return DraggableScrollableSheet(
      initialChildSize: .2,
      maxChildSize: .5,
      minChildSize: .2,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              // border: Border.all(color: Theme.of(context).primaryColor),
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(getRelativeScreenWidth(context, 32)),
                  bottom: Radius.zero),
            ),

            //color: Colors.white,
            width: screenWidth,
            height: screenHeight * .485,
            child: Stack(
              children: [
                Positioned(
                  top: getRelativeScreenHeight(context, 40),
                  left: getRelativeScreenHeight(context, 20),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Popular Places",
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: getRelativeScreenHeight(context, 30),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getRelativeScreenHeight(context, 120),
                    //left: getRelativeScreenHeight(context, 20),
                  ),
                  child: StreamBuilder(
                    stream: umapFirestoreStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        default:
                          List<DocumentSnapshot> umapSourceDocuments =
                              snapshot.data!.docs;
                          return Container(
                            height: getRelativeScreenHeight(context, 240),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              //itemExtent: getRelativeScreenWidth(context, 240),
                              itemCount: umapSourceDocuments.length,
                              itemBuilder: (context, index) =>
                                  buildPopularPlacesList(
                                context,
                                umapSourceDocuments[index],
                              ),
                            ),
                          );
                      }
                    },
                  ),
                ),

                ///Draggable icon indicator
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: getRelativeScreenHeight(context, 5),
                      width: getRelativeScreenWidth(context, 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
