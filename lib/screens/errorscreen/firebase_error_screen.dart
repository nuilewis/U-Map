import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/size_config.dart';

class UmapErrorScreen extends StatelessWidget {
  final String errorDetails;
  final String errorMessage;
  final bool showBackButton;

  const UmapErrorScreen(
      {Key? key,
      required this.errorDetails,
      required this.errorMessage,
      required this.showBackButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: showBackButton
            ? AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    icon: SvgPicture.asset(
                      "assets/svg/back_icon.svg",
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              )
            : null,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage,
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: getRelativeScreenHeight(context, 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getRelativeScreenWidth(context, 30)),
                child: Text(
                  errorDetails,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            ],
          ),
        ));
  }
}
