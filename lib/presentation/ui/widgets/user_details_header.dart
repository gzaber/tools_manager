import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/user.dart';
import '../../helpers/helpers.dart';

class UserDetailsHeader extends StatelessWidget {
  final User user;
  final int numberOfToolsInStock;
  final int numberOfTransferredTools;
  final int numberOfReceivedTools;

  const UserDetailsHeader({
    Key? key,
    required this.user,
    required this.numberOfToolsInStock,
    required this.numberOfTransferredTools,
    required this.numberOfReceivedTools,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavyBlueDark,
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 2.0),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            getUserIcon(user.role),
            color: numberOfToolsInStock == 0 &&
                    numberOfTransferredTools == 0 &&
                    numberOfReceivedTools == 0
                ? kRed
                : kGreen,
            size: 30.0,
          ),
          const SizedBox(width: 16.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 10.0),
                if (numberOfToolsInStock == 0 &&
                    numberOfTransferredTools == 0 &&
                    numberOfReceivedTools == 0)
                  Text(
                    AppLocalizations.of(context)!.zeroTools,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: kRed),
                  ),
                if (numberOfToolsInStock > 0)
                  Text(
                    AppLocalizations.of(context)!
                        .toolsInStock(numberOfToolsInStock),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: kGreen),
                  ),
                if (numberOfTransferredTools > 0)
                  Text(
                    AppLocalizations.of(context)!
                        .transferredTools(numberOfTransferredTools),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: kPink),
                  ),
                if (numberOfReceivedTools > 0)
                  Text(
                    AppLocalizations.of(context)!
                        .receivedTools(numberOfReceivedTools),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: kYellow),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
