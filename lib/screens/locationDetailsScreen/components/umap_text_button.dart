import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class UmapTextButton extends StatelessWidget {
  final String buttonText;
  final String buttonIconLink;
  final VoidCallback? onPressed;
  final bool isDoingWork;

  const UmapTextButton(
      {Key? key,
      required this.buttonText,
      required this.buttonIconLink,
      required this.isDoingWork,
      this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ///Get Directions Button
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: getRelativeScreenWidth(context, 60),
        width: getRelativeScreenWidth(context, 150),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(
            getRelativeScreenWidth(context, 20),
          ),
        ),

        //check if is doing work and return circular progress indicator or actual button
        child: isDoingWork
            ? Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    //valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    width: getRelativeScreenWidth(context, 5),
                  ),
                  SvgPicture.asset(
                    buttonIconLink,
                    color: Colors.white,
                    //height: 20,
                  ),
                ],
              ),
      ),
    );
  }
}
