import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

class ToolRoomTabBar extends StatefulWidget {
  final List<Widget> titles;
  final List<Widget> tabViews;

  const ToolRoomTabBar({
    Key? key,
    required this.titles,
    required this.tabViews,
  }) : super(key: key);

  @override
  _ToolRoomTabBarState createState() => _ToolRoomTabBarState();
}

class _ToolRoomTabBarState extends State<ToolRoomTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.titles.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kNavyBlueLight,
          height: 50.0,
          margin: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: TabBar(
            indicator: const BoxDecoration(color: kNavyBlueDark),
            controller: _tabController,
            tabs: List.generate(
              widget.titles.length,
              (index) => Tab(
                child: widget.titles[index],
              ),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(widget.tabViews.length, (index) => widget.tabViews[index]),
          ),
        )
      ],
    );
  }
}
