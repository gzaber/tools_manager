import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

class HomeMenuItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  final String? greenInfo;
  final String? redInfo;
  final String? whiteInfo;
  final String? pinkInfo;
  final String? yellowInfo;

  const HomeMenuItemCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.greenInfo,
    this.redInfo,
    this.whiteInfo,
    this.pinkInfo,
    this.yellowInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: kNavyBlueLight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10.0),
                      if (greenInfo != null)
                        Text(
                          greenInfo!,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: kGreen),
                        ),
                      if (redInfo != null)
                        Text(
                          redInfo!,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: kRed),
                        ),
                      if (whiteInfo != null)
                        Text(
                          whiteInfo!,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                        ),
                      if (pinkInfo != null)
                        Text(
                          pinkInfo!,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: kPink),
                        ),
                      if (yellowInfo != null)
                        Text(
                          yellowInfo!,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: kYellow),
                        ),
                    ],
                  ),
                ),
                Icon(
                  icon,
                  size: 70.0,
                  color: kOrange,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
