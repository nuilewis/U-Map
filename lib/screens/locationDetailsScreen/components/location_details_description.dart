import 'package:flutter/material.dart';

import '../../../size_config.dart';

class LocDetailsDescriptionSection extends StatelessWidget {
  final String name;
  final String description;

  const LocDetailsDescriptionSection(
      {Key? key, required this.name, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getRelativeScreenWidth(context, 20)),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.left,
            ),
            Divider(
              color: Theme.of(context).primaryColorLight,
              thickness: getRelativeScreenHeight(context, 5),
              endIndent: MediaQuery.of(context).size.width * .7,
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 15),
            ),
            Text(description),
            SizedBox(height: getRelativeScreenHeight(context, 30)),
          ],
        ),
      ),
    );
  }
}
