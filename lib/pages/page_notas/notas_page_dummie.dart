import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'dart:math';

class AnimatedContainerApp extends StatefulWidget {
  @override
  _AnimatedContainerAppState createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AnimatedContainer Demo'),
        ),
        body: Center(
          child: AnimatedContainer(
            // Use the properties stored in the State class.
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            // Define how long the animation should take.
            duration: Duration(seconds: 1),
            // Provide an optional curve to make the animation feel smoother.
            curve: Curves.fastOutSlowIn,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          // When the user taps the button
          onPressed: () {
            // Use setState to rebuild the widget with new values.
            setState(() {
              // Create a random number generator.
              final random = Random();

              // Generate a random width and height.
              _width = random.nextInt(300).toDouble();
              _height = random.nextInt(300).toDouble();

              // Generate a random color.
              _color = Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              );

              // Generate a random border radius.
              _borderRadius =
                  BorderRadius.circular(random.nextInt(100).toDouble());
            });
          },
        ),
      ),
    );
  }
}
//final Color backgroundColor = Color(0xFF4A4A58);

class NotasdPage extends StatefulWidget {
  NotasdPage({Key key, @required this.storage}) : super(key: key);

  final FlutterSecureStorage storage;
  static const String routeName = '/notas';
  @override
  _NotasdPageState createState() => _NotasdPageState();
}

class _NotasdPageState extends State<NotasdPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  double _offsetContainer;
  var _text;
  var _oldtext;
  var _heightscroller;
  var _itemsizeheight = 65.0; //NOTE: size items
  var _marginRight = 50.0;
  var _sizeheightcontainer;
  var posSelected = 0;
  var diff = 0.0;
  var height = 0.0;
  var txtSliderPos = 0.0;
  ScrollController _scrollController;
  String message = "";

  List exampleList = [
    '1',
    '2',
    '3',
    '4',
    'Axvfgfdg',
    'Axvfgfdg2',
    'Axvfgfdg3',
    'Bsdadasd',
    'Bsdadasd2',
    'Bsdadasd3',
    'Cat',
    'Cat2',
    'Cat3',
    'Dog',
    'Dog2',
    'Dog3',
    'Elephant',
    'Elephant2',
    'Elephant3',
    'Fans',
    'Girls',
    'Hiiii',
    'Ilu',
    'Jeans',
    'Kite',
    'Lion',
    'Men',
    'Nephow',
    'Owl',
    'Please',
    'Quat',
    'Rose',
    'Salt',
    'Trolly',
    'Up',
    'View',
    'Window',
    'Xbox',
    'Yellow',
    'Yummy',
    'Zubin',
    'Zara',
    'Fans2',
    'Girls2',
    'Hiiii2',
    'Ilu2',
    'Jeans2',
    'Kite2',
    'Lion2',
    'Men2',
    'Nephow2',
    'Owl2',
    'Please2',
    'Quat2',
    'Rose2',
    'Salt2',
    'Trolly2',
    'Up2',
    'View2',
    'Window2',
    'Xbox2',
    'Yellow2',
    'Yummy2',
    'Zubin2',
    'Zara2'
  ];

  Map<String, dynamic> cursos = {
    '': '',
    '': '',
  };
  List _alphabetCursos = [
    {'Comunicación':''},
    'Matemática',
    'Física',
    'Sociales',
    'Ciencias',
    'Relgión',
    'Hisotria',
    'Cívica',
    'Lengua extranjera',
    'Música',
    'Pintura',
    'Escritura',
  ];

  List _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  HijoModel _currentChildSelected;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);

    _offsetContainer = 0.0;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    //sort the item list
    exampleList.sort((a, b) {
      return a.toString().compareTo(b.toString());
    });

    super.initState();
    this._loadChildSelectedStorageFlow();
  }

//scroll detector for reached top or bottom
  _scrollListener() {
    if ((_scrollController.offset) >=
        (_scrollController.position.maxScrollExtent)) {
      print("reached bottom");
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reached top");
    }
  }

  Future _loadChildSelectedStorageFlow() async {
    var childSelected = await widget.storage.read(key: 'child_selected');
    var currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    this._currentChildSelected =
        this._currentChildSelected ?? currentChildSelected;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 &&
          (_offsetContainer + details.delta.dy) <=
              (_sizeheightcontainer - _heightscroller)) {
        _offsetContainer += details.delta.dy;
        posSelected =
            ((_offsetContainer / _heightscroller) % _alphabet.length).round();
        _text = _alphabet[posSelected];
        if (_text != _oldtext) {
          for (var i = 0; i < exampleList.length; i++) {
            if (_text
                    .toString()
                    .compareTo(exampleList[i].toString().toUpperCase()[0]) ==
                0) {
              _scrollController.jumpTo(i * _itemsizeheight);
              break;
            }
          }
          _oldtext = _text;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
//    var heightAfterToolbar = height - diff;
//    print("height1 $heightAfterToolbar");
//    var remavingHeight = heightAfterToolbar - (20.0 * 26);
//    print("height2 $remavingHeight");
//
//    var reducedheight = remavingHeight / 2;
//    print("height3 $reducedheight");
    _offsetContainer = details.globalPosition.dy - diff;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) async {
          this._currentChildSelected = childSelected;
          await _loadChildSelectedStorageFlow();
        },
      ),
      appBar: AppBarLamb(
        title: Text('AGENDA'),
        alumno: this._currentChildSelected,
      ),
      body: buildList(context),
    );
  }

  Widget buildList(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return new LayoutBuilder(
      builder: (context, contrainsts) {
        diff = height - contrainsts.biggest.height;
        _heightscroller = (contrainsts.biggest.height) / _alphabet.length;
        _sizeheightcontainer = (contrainsts.biggest.height); //NO
        return new Stack(children: [
          ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: exampleList.length,
            controller: _scrollController,
            itemExtent: _itemsizeheight,
            itemBuilder: (context, position) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    exampleList[position],
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              );
            },
          ),
          /*Positioned(
              right: _marginRight,
              top: _offsetContainer,
              child: _getSpeechBubble(),
            ),*/
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragStart: _onVerticalDragStart,
              child: Container(
                //height: 20.0 * 26,
                color: Colors.transparent,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: []..addAll(
                      new List.generate(
                          _alphabet.length, (index) => _getAlphabetItem(index)),
                    ),
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }

  ValueGetter callback(int value) {}

  _getAlphabetItem(int index) {
    return new Expanded(
      child: new Container(
        width: 40,
        height: 20,
        alignment: Alignment.center,
        child: new Text(
          _alphabet[index],
          style: (index == posSelected)
              ? new TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
              : new TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget body() {
    return Scaffold(
      //backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    TextStyle ts = TextStyle(fontSize: 22);
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Dashboard", style: ts),
                SizedBox(height: 10),
                Text("Messages", style: ts),
                SizedBox(height: 10),
                Text("Utility Bills", style: ts),
                SizedBox(height: 10),
                Text("Funds Transfer", style: ts),
                SizedBox(height: 10),
                Text("Branches", style: ts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final ScrollController _controllerOne = ScrollController();

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          //color: backgroundColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            controller: _controllerOne,
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.menu,
                        ),
                        onTap: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                      Text("My Cards",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Icon(
                        Icons.settings,
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 200,
                    child: PageView(
                      physics: BouncingScrollPhysics(),
                      controller: PageController(
                          viewportFraction: 0.9,
                          keepPage: false,
                          initialPage: 1),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.redAccent,
                          width: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.blueAccent,
                          width: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.greenAccent,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  double _width = 100;
  double _height = 100;
  Color _color = Colors.lightBlue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  Widget body2() {
    return Scaffold(
      body: Center(
          child: DraggableCard(
        child: AnimatedContainer(
          // Use the properties stored in the State class.
          width: _width,
          height: 400,
          /*decoration: BoxDecoration(
            color: _color,
            borderRadius: _borderRadius,
          ),*/
          // Define how long the animation should take.
          duration: Duration(seconds: 1),
          // Provide an optional curve to make the animation feel smoother.
          curve: Curves.fastOutSlowIn,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              InkWell(
                  customBorder:
                      Border.all(style: BorderStyle.solid, color: Colors.lime),
                  child: ListTile(title: Text('Matemática'))),
              InkWell(child: ListTile(title: Text('Comunicación'))),
              InkWell(child: ListTile(title: Text('Matemática'))),
              InkWell(child: ListTile(title: Text('Matemática'))),
              InkWell(child: ListTile(title: Text('Matemática'))),
              InkWell(child: ListTile(title: Text('Matemática'))),
              InkWell(child: ListTile(title: Text('Matemática'))),
              InkWell(child: ListTile(title: Text('Matemática'))),
              InkWell(child: ListTile(title: Text('Matemática'))),
            ],
          ),
        ),
      )),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        // When the user taps the button
        onPressed: () {
          // Use setState to rebuild the widget with new values.
          setState(() {
            // Create a random number generator.
            final random = Random();

            // Generate a random width and height.
            _width = random.nextInt(300).toDouble();
            _height = random.nextInt(300).toDouble();

            // Generate a random color.
            _color = Color.fromRGBO(
              random.nextInt(256),
              random.nextInt(256),
              random.nextInt(256),
              0.5,
            );

            // Generate a random border radius.
            _borderRadius =
                BorderRadius.circular(random.nextInt(100).toDouble());
          });
        },
      ),*/
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;
  DraggableCard({this.child});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment.center;

  Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: _dragAlignment,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /*_onDragUpdate(context, update) {
    print(update);
  }*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      //behavior: HitTestBehavior.translucent,
      //onHorizontalDragEnd: (DragEndDetails dragEndDetails) =>_onDragUpdate(context, dragEndDetails),
      //onHorizontalDragUpdate: (DragUpdateDetails update) =>_onDragUpdate(context, update),

      onPanDown: (details) {
        _controller.stop();
      },
      /*onPanStart: (details) {
        _runAnimation(null, size);
      },*/
      onPanUpdate: (details) {
        //print(details);
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 0),
          );
          if (details.delta.dx > 0) /*+*/ {
            _dragAlignment = Alignment.center;
          } else if (details.delta.dx < 0) /*-*/ {
            _dragAlignment = Alignment.centerLeft;
          } else {
            //_dragAlignment = Alignment.centerRight;
          }
        });
      },
      /*onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },*/
      child: Align(
        alignment: _dragAlignment,
        child: widget.child,
      ),
    );
  }
}
