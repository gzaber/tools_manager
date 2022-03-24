import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/tool_model.dart';
import 'colors.dart';
import 'constants.dart';
import 'enums.dart';

ToolStatusByUserOption getToolStatusByUser(ToolModel toolModel, String username) {
  if (username == toolModel.receiver) return ToolStatusByUserOption.received;
  if (username == toolModel.holder && toolModel.receiver == null) {
    if (toolModel.giver == null) {
      return ToolStatusByUserOption.added;
    } else {
      return ToolStatusByUserOption.given;
    }
  } else {
    return ToolStatusByUserOption.transferred;
  }
}

IconData getUserIcon(String userRole) {
  if (userRole == kRoleMaster) return Icons.engineering;
  if (userRole == kRoleAdmin) return Icons.manage_accounts;
  return Icons.person;
}

Color getToolIconColor(ToolModel toolModel, String username) {
  ToolStatusByUserOption toolStatusByUserOption = getToolStatusByUser(toolModel, username);
  if (toolStatusByUserOption == ToolStatusByUserOption.received) return kYellow;
  if (toolStatusByUserOption == ToolStatusByUserOption.transferred) {
    return kPink;
  }
  return kGreen;
}

getCurrentDate() {
  return DateFormat('dd-MM-yyyy').format(DateTime.now());
}
