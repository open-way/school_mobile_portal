import 'package:flutter/material.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({
    Key key,
    this.title,
    this.children,
    this.actions,
    this.isDivider,
    this.shrinkWrap,
    this.opacity,
    this.shape,
    this.width,
    this.floatingActionButton,
    this.buttonBarPadding,
    this.titleStyle,
  }) : super(key: key);

  final String title;
  final TextStyle titleStyle;
  final List<Widget> children;
  final List<Widget> actions;
  final bool isDivider;
  final bool shrinkWrap;
  final double opacity;
  final ShapeBorder shape;
  final double width;
  final Widget floatingActionButton;
  final double buttonBarPadding;

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  TextStyle _titleStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 20);
  List<Widget> _children = [];
  List<Widget> _actions = [];
  bool _isDivider = false;
  bool _shrinkWrap = true;
  bool _isTitle = false;
  double _opacity = 0.825;
  ShapeBorder _shape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
  double _width = double.maxFinite;
  Widget _floatingActionButton = Center();
  double _buttonBarPadding = 5;

  @override
  void initState() {
    super.initState();
    customValidator();
  }

  customValidator() {
    _isTitle = widget.title == null ? _isTitle : true;

    _titleStyle = widget.titleStyle == null ? _titleStyle : widget.titleStyle;
    _children = widget.children == null ? _children : widget.children;
    _actions = widget.actions == null ? _actions : widget.actions;
    _isDivider = widget.isDivider == null ? _isDivider : widget.isDivider;
    _shrinkWrap = widget.shrinkWrap == null ? _shrinkWrap : widget.shrinkWrap;
    _opacity = widget.opacity == null ? _opacity : widget.opacity;
    _shape = widget.shape == null ? _shape : widget.shape;
    _width = widget.width == null ? _width : widget.width;
    _floatingActionButton = widget.floatingActionButton == null
        ? _floatingActionButton
        : widget.floatingActionButton;
    _buttonBarPadding = widget.buttonBarPadding == null
        ? _buttonBarPadding
        : widget.buttonBarPadding;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          LambThemes.light.scaffoldBackgroundColor.withOpacity(_opacity),
      shape: this._shape,
      child: Container(
        //height: double.nan,
        /*decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Colors.transparent,
                LambThemes.light.backgroundColor.withOpacity(0.2)
              ],
              //begin: Alignment(0, 2250),
              //end: Alignment(0, 0),
              tileMode: TileMode.repeated),
        ),*/
        width: this._width,
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.all(0),
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: this._shrinkWrap,
              children: <Widget>[
                    this._isTitle
                        ? ListTile(
                            contentPadding: EdgeInsets.all(0),
                            dense: true,
                            title: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(
                                '${widget.title}',
                                textAlign: TextAlign.center,
                                style: _titleStyle,
                              ),
                            ),
                          )
                        : Center(),
                  ] +
                  this._children +
                  [
                    this._isDivider
                        ? Divider(
                            height: 0,
                            indent: 0,
                            endIndent: 0,
                            color: LambThemes.light.backgroundColor,
                            thickness: 1.5,
                          )
                        : Center(),
                    ButtonBar(
                      buttonPadding: EdgeInsets.all(this._buttonBarPadding),
                      mainAxisSize: MainAxisSize.max,
                      alignment: MainAxisAlignment.spaceAround,
                      children: this._actions,
                    ),
                  ],
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomRight,
                child: this._floatingActionButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
