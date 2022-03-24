import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/tool.dart';
import 'colors.dart';
import 'constants.dart';
import 'enums.dart';

ToolStatusByUserOption getToolStatusByUser(Tool tool, String username) {
  if (username == tool.receiver) return ToolStatusByUserOption.received;
  if (username == tool.holder && tool.receiver == null) {
    if (tool.giver == null) {
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

Color getToolIconColor(Tool tool, String username) {
  ToolStatusByUserOption toolStatusByUserOption =
      getToolStatusByUser(tool, username);
  if (toolStatusByUserOption == ToolStatusByUserOption.received) return kYellow;
  if (toolStatusByUserOption == ToolStatusByUserOption.transferred) {
    return kPink;
  }
  return kGreen;
}

getCurrentDate() {
  return DateFormat('dd-MM-yyyy').format(DateTime.now());
}
