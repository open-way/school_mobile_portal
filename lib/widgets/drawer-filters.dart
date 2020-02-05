import 'package:flutter/material.dart';

class DrawerFilters extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;

  DrawerFilters({@required this.child, this.onClose});

  @override
  _DrawerFilters createState() => _DrawerFilters();
}

class _DrawerFilters extends State<DrawerFilters> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[widget.child],
      ),
    );
  }
}
