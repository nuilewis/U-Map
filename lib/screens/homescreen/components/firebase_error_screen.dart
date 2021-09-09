import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/size_config.dart';

class UmapFireStoreError extends StatelessWidget {
  final String firebaseErrorDetails;
  final String firebaseErrorMsg;

  const UmapFireStoreError(
      {Key? key,
      required this.firebaseErrorDetails,
      required this.firebaseErrorMsg})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: SvgPicture.asset(
                "assets/svg/back_icon.svg",
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                firebaseErrorMsg,
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: getRelativeScreenHeight(context, 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getRelativeScreenWidth(context, 30)),
                child: Text(
                  firebaseErrorDetails,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            ],
          ),
        ));
  }
}
