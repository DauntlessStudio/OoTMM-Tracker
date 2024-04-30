import 'package:flutter/material.dart';
import 'package:ootmm_tracker/widgets/count_icon.dart';
import 'package:ootmm_tracker/widgets/state_icon.dart';
import 'package:ootmm_tracker/widgets/toggle_icon.dart';

class TrackerItem {
  TrackerItem();

  Widget getWidget() {
    return Image.asset("images/sold_out.png");
  }
}

class TrackerToggleItem extends TrackerItem {
  final String icon;

  TrackerToggleItem(this.icon);

  @override
  Widget getWidget() {
    return ToggleIcon(icon: icon);
  }
}

class TrackerStateItem extends TrackerItem {
  final List<String> icons;

  TrackerStateItem(this.icons);

  @override
  Widget getWidget() {
    return StateIcon(icons: icons);
  }
}

class TrackerCountItem extends TrackerItem {
  final String icon;
  final int max;

  TrackerCountItem(this.icon, this.max);

  @override
  Widget getWidget() {
    return CountIcon(icon: icon, max: max);
  }
}