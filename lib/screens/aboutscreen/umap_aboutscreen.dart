import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../size_config.dart';

class UmapAboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset("assets/svg/back_icon.svg")),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .2,
                      vertical: screenSize.height * .05),
                  child: SvgPicture.asset(
                    "assets/svg/umap_logo.svg",
                    height: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "U-map is a way-finding app made by the students of the university of Bamenda for students of the University of Bamenda. It helps students easily locate any class, or office or administrative building, while providing distance calculations, route directions and more! ",
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: getRelativeScreenHeight(context, 20),
                ),
                // Text(
                //   "Developed by ",
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyText2!
                //       .copyWith(color: Theme.of(context).primaryColorDark),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Text(
                //   "Alouzeh Brandone",
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),
                // Text(
                //   "Nuikweh Lewis",
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),
                // SizedBox(
                //   height: 30,
                // ),
                // Text(
                //   "Special Thanks to",
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyText2!
                //       .copyWith(color: Theme.of(context).primaryColorDark),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Text(
                //   "Elroy Kanye",
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),
                // Text(
                //   "Nfon Andrew Tata",
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),
                // Text(
                //   "Ngumih Fien",
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),
                // Text(
                //   "Smart Arena Photography",
                //   style: Theme.of(context).textTheme.bodyText1,
                // )
              ],
            ),
          ),
        ));
  }
}
