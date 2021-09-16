import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class UmapTextButton extends StatelessWidget {
  final String buttonText;
  final String buttonIconLink;
  final VoidCallback? onPressed;

  const UmapTextButton(
      {Key? key,
      required this.buttonText,
      required this.buttonIconLink,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              width: getRelativeScreenWidth(context, 5),
            ),
            SvgPicture.asset(
              buttonIconLink,
              color: Theme.of(context).iconTheme.color,
              //height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
