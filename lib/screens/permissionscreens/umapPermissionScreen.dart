import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_map/constants.dart';

import '../../size_config.dart';

class UmapPermissionsScreen extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const UmapPermissionsScreen(
      {Key? key,
      required this.title,
      required this.message,
      required this.buttonText,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //       icon: SvgPicture.asset(
      //         "assets/svg/back_icon.svg",
      //         color: Theme.of(context).iconTheme.color,
      //       ),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       }),
      // ),
      body: Center(
        child: Column(
          ///Text area
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(
              flex: 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getRelativeScreenWidth(context, 20)),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 20),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getRelativeScreenWidth(context, 30)),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),

            SizedBox(
              height: getRelativeScreenHeight(context, 60),
            ),

            ///Accept Button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getRelativeScreenWidth(context, 20)),
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                  height: getRelativeScreenWidth(context, 60),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cPrimaryColor,
                    borderRadius: BorderRadius.circular(
                      getRelativeScreenWidth(context, 20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        buttonText,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(
                        width: getRelativeScreenWidth(context, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 30),
            ),

            ///Refuse button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getRelativeScreenWidth(context, 20)),
              child: GestureDetector(
                onTap: () {
                  Feedback.forTap(context);
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Container(
                  height: getRelativeScreenWidth(context, 60),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border:
                        Border.all(color: Theme.of(context).iconTheme.color!),
                    borderRadius: BorderRadius.circular(
                      getRelativeScreenWidth(context, 20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "No thanks!",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        width: getRelativeScreenWidth(context, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
