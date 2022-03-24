import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/user_model.dart';
import '../../helpers/helpers.dart';

class UserListItemCard extends StatelessWidget {
  final UserModel userModel;
  final int numberOfToolsInStock;
  final int numberOfTransferredTools;
  final int numberOfReceivedTools;
  final Function() onTap;
  final Function()? onLongPressed;

  const UserListItemCard({
    Key? key,
    required this.userModel,
    required this.numberOfToolsInStock,
    required this.numberOfTransferredTools,
    required this.numberOfReceivedTools,
    required this.onTap,
    required this.onLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: kNavyBlueLight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: onLongPressed,
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(
                        getUserIcon(userModel.role),
                        color: numberOfToolsInStock == 0 &&
                                numberOfTransferredTools == 0 &&
                                numberOfReceivedTools == 0
                            ? kRed
                            : kGreen,
                        size: 25.0,
                      ),
                      const SizedBox(width: 16.0),
                      Flexible(
                        child: Text(
                          userModel.name,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: Colors.white,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (numberOfToolsInStock == 0 &&
                        numberOfTransferredTools == 0 &&
                        numberOfReceivedTools == 0)
                      Text(
                        AppLocalizations.of(context)!.zeroTools,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: kRed),
                      ),
                    if (numberOfToolsInStock > 0)
                      Text(
                        AppLocalizations.of(context)!.toolsInStock(numberOfToolsInStock),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: kGreen),
                      ),
                    if (numberOfTransferredTools > 0)
                      Text(
                        AppLocalizations.of(context)!.transferredTools(numberOfTransferredTools),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: kPink),
                      ),
                    if (numberOfReceivedTools > 0)
                      Text(
                        AppLocalizations.of(context)!.receivedTools(numberOfReceivedTools),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: kYellow),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
