import 'package:flutter/material.dart';
import 'package:ootmm_tracker/widgets/count_icon.dart';
import 'package:ootmm_tracker/widgets/hex_color.dart';
import 'package:ootmm_tracker/widgets/state_icon.dart';
import 'package:ootmm_tracker/widgets/toggle_icon.dart';

enum TrackerType {
  static, toggle, state, count
}

class TrackerItem {
  final String name;
  final String icon;

  TrackerItem(this.name, this.icon);

  Widget getWidget() {
    return Image.asset(icon);
  }

  factory TrackerItem.fromJson(Map<String, dynamic> data) {
    final trackerType = TrackerType.values.byName(data["type"]);
    final name = data["name"] as String? ?? "";
    final icon = data["icon"] as String? ?? "";
    switch (trackerType) {
      case TrackerType.toggle:
        return TrackerToggleItem(name, icon, false);
      case TrackerType.state:
        final icons = (data["icons"] as List<dynamic>).map((e) => e.toString()).toList();
        return TrackerStateItem(name, icon, icons);
      case TrackerType.count:
        final max = data["max"] as int;
        return TrackerCountItem(name, icon, max);
      default:
        return TrackerItem(name, icon);
    }
  }
}

class TrackerToggleItem extends TrackerItem {
  final bool state;

  TrackerToggleItem(super.name, super.icon, this.state);

  @override
  Widget getWidget() {
    return ToggleIcon(icon: icon);
  }
}

class TrackerStateItem extends TrackerItem {
  final List<String> icons;

  TrackerStateItem(super.name, super.icon, this.icons);

  @override
  Widget getWidget() {
    return StateIcon(icons: icons);
  }
}

class TrackerCountItem extends TrackerItem {
  final int max;

  TrackerCountItem(super.name, super.icon, this.max);

  @override
  Widget getWidget() {
    return CountIcon(icon: icon, max: max);
  }
}

class TrackerBox {
  final String name;
  final int columns;
  final BoxConstraints constraints;
  final ColorScheme? colorScheme;
  final Offset? offset;
  final List<TrackerItem> entries;

  TrackerBox({required this.name, required this.columns, required this.entries, required this.constraints, this.colorScheme, this.offset});

  factory TrackerBox.fromJson(Map<String, dynamic> data) {
    final String name = data["name"] as String;

    final int columns = data["columns"] as int;

    final double width = data["width"] as double? ?? 300;
    final double height = data["height"] as double? ?? 300;
    final BoxConstraints constraints = BoxConstraints.tight(Size(width, height));

    final List<dynamic> entriesRaw = data["entries"] as List<dynamic>;
    final List<TrackerItem> entries = entriesRaw.map<TrackerItem>((value) => TrackerItem.fromJson(value)).toList();
    
    final ColorScheme? colorScheme = data["color"] != null ? ColorScheme.fromSeed(seedColor: HexColor(data["color"] as String)) : null;

    final List<double>? offsetRaw = data["offset"] != null
      ? (data["offset"] as List<dynamic>).map((e) => e as double).toList()
      : null;
    final Offset? offset = offsetRaw != null ? Offset(offsetRaw[0], offsetRaw[1]) : null;

    return TrackerBox(name: name, columns: columns, entries: entries, constraints: constraints, colorScheme: colorScheme, offset: offset);
  }

  Container getWidget() {
    final List<Widget> children = entries.map((e) => e.getWidget()).toList();
    return Container(
      decoration: BoxDecoration(
        color: colorScheme?.primary,
        border: colorScheme != null ? Border.all(
          color: colorScheme!.secondary,
          strokeAlign: BorderSide.strokeAlignOutside,
        ) : null,
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: columns,
        children: children,
      ),
    );
  }
}

class TrackerGroup {
  final String name;
  final BoxConstraints constraints;
  final ColorScheme? colorScheme;
  final Offset? offset;
  final List<TrackerBox> layouts;

  TrackerGroup({required this.name, required this.layouts, required this.constraints, this.colorScheme, this.offset});

  factory TrackerGroup.fromJson(Map<String, dynamic> data) {
    final String name = data["name"] as String;

    final double width = data["width"] as double? ?? 300;
    final double height = data["height"] as double? ?? 300;
    final BoxConstraints constraints = BoxConstraints.tight(Size(width, height));

    final List<TrackerBox> layouts = (data["layouts"] as List<dynamic>).map((e) => TrackerBox.fromJson(e)).toList();
    
    final ColorScheme? colorScheme = data["color"] != null ? ColorScheme.fromSeed(seedColor: HexColor(data["color"] as String)) : null;

    final List<double>? offsetRaw = data["offset"] != null
      ? (data["offset"] as List<dynamic>).map((e) => e as double).toList()
      : null;
    final Offset? offset = offsetRaw != null ? Offset(offsetRaw[0], offsetRaw[1]) : null;

    return TrackerGroup(name: name, layouts: layouts, constraints: constraints, colorScheme: colorScheme, offset: offset);
  }

  Container getWidget() {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme?.primary,
        border: colorScheme != null ? Border.all(
          color: colorScheme!.secondary,
          strokeAlign: BorderSide.strokeAlignOutside,
        ) : null,
      ),
      alignment: Alignment.topLeft,
      child: CustomMultiChildLayout(
      delegate: _TrackeGroupDelegate(layouts),
      children: <Widget>[
        for (final TrackerBox tracker in layouts) 
          LayoutId(id: tracker.name, child: tracker.getWidget())
        ],
      ),
    );
  }
}

class Tracker {
  final List<TrackerGroup> groups;

  Tracker(this.groups);

  factory Tracker.fromJson(Map<String, dynamic> data) {
    final List<TrackerGroup> groups = (data["groups"] as List<dynamic>).map((e) => TrackerGroup.fromJson(e)).toList();
    return Tracker(groups);
  }

  CustomMultiChildLayout getWidget() {
    return CustomMultiChildLayout(
      delegate: _TrackerLayoutDelegate(groups),
      children: <Widget>[
        for (final TrackerGroup group in groups) 
          LayoutId(id: group.name, child: group.getWidget())
      ],
    );
  }
}

class _TrackerLayoutDelegate extends MultiChildLayoutDelegate {
  final List<TrackerGroup> trackers;

  _TrackerLayoutDelegate(this.trackers);

  @override
  void performLayout(Size size) {
    for (final TrackerGroup tracker in trackers) {
      layoutChild(tracker.name, tracker.constraints);
      positionChild(tracker.name, tracker.offset != null ? tracker.offset! : Offset.zero);
    }
  }

  @override
  bool shouldRelayout(covariant _TrackerLayoutDelegate oldDelegate) {
    return oldDelegate.trackers != trackers;
  }

}

class _TrackeGroupDelegate extends MultiChildLayoutDelegate {
  final List<TrackerBox> trackers;

  _TrackeGroupDelegate(this.trackers);

  @override
  void performLayout(Size size) {
    for (final TrackerBox tracker in trackers) {
      layoutChild(tracker.name, tracker.constraints);
      positionChild(tracker.name, tracker.offset != null ? tracker.offset! : Offset.zero);
    }
  }

  @override
  bool shouldRelayout(covariant _TrackeGroupDelegate oldDelegate) {
    return oldDelegate.trackers != trackers;
  }

}