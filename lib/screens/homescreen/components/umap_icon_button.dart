import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class UmapIconButton extends StatelessWidget {
  final String iconLink;
  final VoidCallback? onPressed;
  final Color? bgColor;
  final Color? iconColor;

  const UmapIconButton(
      {Key? key,
      required this.iconLink,
      this.onPressed,
      this.bgColor,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getRelativeScreenWidth(context, 60),
      height: getRelativeScreenWidth(context, 60),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(
          getRelativeScreenWidth(context, 20),
        ),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          iconLink,
          color: iconColor ?? Theme.of(context).iconTheme.color,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
