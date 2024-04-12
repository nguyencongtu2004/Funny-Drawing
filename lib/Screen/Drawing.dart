import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Drawing extends StatefulWidget {
  const Drawing({Key? key}) : super(key: key);

  @override
  State<Drawing> createState() => _Drawing();
}

class _Drawing extends State<Drawing> {
  late Offset _containerPosition;
  late bool _isSizeMenuVisible;
  late Offset _containerPositionSize;
  late bool _isSelectMenuVisible;
  late Color _paintColor;
  late double _paintSize;
  late IconData _selectIcon;
  final GlobalKey _sizemenu = GlobalKey();
  final GlobalKey _selectmenu = GlobalKey();
  final GlobalKey<_PaintBoardState> _paintBoardKey = GlobalKey();
  String chose = "Draw";

  @override
  void initState() {
    super.initState();
    _isSelectMenuVisible = false;
    _containerPosition = Offset.zero;
    _paintColor = Colors.black;
    _paintSize = 5;
    _selectIcon = Icons.draw;
    _isSizeMenuVisible = false;
    _containerPositionSize = Offset.zero;
  }

  void _toggleSelectMenuVisibility(Offset position) {
    setState(() {
      _isSelectMenuVisible = !_isSelectMenuVisible;
      if (_isSelectMenuVisible) _isSizeMenuVisible = false;
      _containerPosition = position;
    });
  }

  void _toggleSizeMenuVisibility(Offset position) {
    setState(() {
      _isSizeMenuVisible = !_isSizeMenuVisible;
      if (_isSizeMenuVisible) _isSelectMenuVisible = false;
      _containerPositionSize = position;
      print("true");
    });
  }

  void _setColor(Color cl) {
    setState(() {
      _paintColor = cl;
    });
  }

  void _setPainSize(double size) {
    setState(() {
      _paintSize = size;
    });
  }

  void _setSelectIcon(IconData ic) {
    setState(() {
      _selectIcon = ic;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Color mainColor = Color(0xFF00C4A1);
    final double sizePickColor = 22;
    return Scaffold(
        body: Stack(
      children: [
        // ----------------------  Draw Area ----------------------
        Positioned(
          top: 0,
          left: 0,
          child: Column(
            children: [
              ClipRect(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: PaintBoard(
                  key: _paintBoardKey,
                  chose: chose,
                  paintColor: _paintColor,
                  paintSize: _paintSize,
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ))
            ],
          ),
        ),
        // ----------------------  MenuBar ----------------------
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: 0,
          child: Container(
              height: 70,
              width: size.width,
              color: mainColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (_selectIcon != Icons.add)
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            7.0), // Bán kính cong của đường viền
                      ),
                      child: IconButton(
                        key: _selectmenu,
                        onPressed: () {
                          RenderBox buttonBox = _selectmenu.currentContext!
                              .findRenderObject() as RenderBox;
                          Offset buttonPosition =
                              buttonBox.localToGlobal(Offset.zero);
                          // Toggle the visibility of the container
                          _toggleSelectMenuVisibility(buttonPosition);
                        },
                        icon: Icon(
                          _selectIcon,
                          color: Colors.black,
                          size: 35, // Màu của biểu tượng
                        ),
                      ),
                    ),
                  if (_selectIcon == Icons.add)
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              7.0), // Bán kính cong của đường viền
                        ),
                        child: GestureDetector(
                          key: _selectmenu,
                          onTap: () {
                            _setColor(Theme.of(context).backgroundColor);
                            _setSelectIcon(Icons.add);
                            RenderBox buttonBox = _selectmenu.currentContext!
                                .findRenderObject() as RenderBox;
                            Offset buttonPosition =
                                buttonBox.localToGlobal(Offset.zero);
                            _toggleSelectMenuVisibility(buttonPosition);
                          },
                          child: Image.asset(
                            'assets/eraser.png', // Đường dẫn đến hình ảnh cục tẩy
                            width: 10,
                            height: 10,
                            color: Colors.black, // Màu của hình ảnh
                          ),
                        )),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          7.0), // Bán kính cong của đường viền
                    ),
                    child: IconButton(
                      key: _sizemenu,
                      onPressed: () {
                        RenderBox buttonBox = _sizemenu.currentContext!
                            .findRenderObject() as RenderBox;
                        Offset buttonPosition =
                            buttonBox.localToGlobal(Offset.zero);
                        // Toggle the visibility of the container
                        _toggleSizeMenuVisibility(buttonPosition);
                      },
                      icon: Icon(
                        Icons.height,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ),
                  // ----------------------  Color Picker ----------------------
                  Container(
                    height: 50,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 205, 234, 1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.black);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.black),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.white);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.white),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.grey);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.grey),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.red);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.red),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.yellow);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.yellow),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.green);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.green),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.blue);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.blue),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.pink);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.pink),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.brown);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.brown),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.cyanAccent);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.cyanAccent),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.greenAccent);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.greenAccent),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.orange);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.orange),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.purple);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.purple),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                            Container(
                              height: sizePickColor,
                              width: sizePickColor,
                              child: ElevatedButton(
                                onPressed: () {
                                  _setColor(Colors.teal);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize:
                                        Size(sizePickColor, sizePickColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius là 5
                                    ),
                                    backgroundColor: Colors.teal),
                                child: SizedBox(
                                  width:
                                      sizePickColor, // Kích thước của hình vuông
                                  height: sizePickColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
        if (_isSizeMenuVisible)
          Positioned(
              left: _containerPositionSize.dx - 5,
              top: _containerPositionSize.dy - 415,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            7.0), // Bán kính cong của đường viền
                      ),
                      child: IconButton(
                        onPressed: () {
                          _setPainSize(5);
                          _toggleSizeMenuVisibility(Offset.zero);
                        },
                        icon: Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 10,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            7.0), // Bán kính cong của đường viền
                      ),
                      child: IconButton(
                        onPressed: () {
                          _setPainSize(8);
                          _toggleSizeMenuVisibility(Offset.zero);
                        },
                        icon: Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 15,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            7.0), // Bán kính cong của đường viền
                      ),
                      child: IconButton(
                        onPressed: () {
                          _setPainSize(12);
                          _toggleSizeMenuVisibility(Offset.zero);
                        },
                        icon: Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 20,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            7.0), // Bán kính cong của đường viền
                      ),
                      child: IconButton(
                        onPressed: () {
                          _setPainSize(16);
                          _toggleSizeMenuVisibility(Offset.zero);
                        },
                        icon: Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 25,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            7.0), // Bán kính cong của đường viền
                      ),
                      child: IconButton(
                        onPressed: () {
                          _setPainSize(22);
                          _toggleSizeMenuVisibility(Offset.zero);
                        },
                        icon: Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        if (_isSelectMenuVisible)
          Positioned(
            left: _containerPosition.dx,
            top: _containerPosition.dy - 290,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: IconButton(
                            onPressed: () {
                              _paintBoardKey.currentState!.clearPoints();
                            },
                            icon: Icon(
                              Icons.delete, // Biểu tượng
                              color: Colors.black, // Màu của biểu tượng
                              size: 35,
                            ),
                          ),
                        ),
                        Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  7.0), // Bán kính cong của đường viền
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _setColor(Theme.of(context).backgroundColor);
                                _setSelectIcon(Icons.add);
                                _toggleSelectMenuVisibility(Offset(0, 0));
                              },
                              child: Image.asset(
                                'assets/eraser.png', // Đường dẫn đến hình ảnh cục tẩy
                                width: 10,
                                height: 10,
                                color: Colors.black, // Màu của hình ảnh
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: IconButton(
                            onPressed: () {
                              _setSelectIcon(Icons.draw);
                              _toggleSelectMenuVisibility(Offset(0, 0));
                              _setColor(Colors.black);
                            },
                            icon: Icon(
                              Icons.draw, // Biểu tượng
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Xử lý khi nút được nhấn
                            },
                            icon: Icon(
                              Icons.delete, // Biểu tượng
                              color: Colors.black, // Màu của biểu tượng
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: IconButton(
                            onPressed: () {
                              _paintBoardKey.currentState!.ctrlZ();
                            },
                            icon: Icon(
                              Icons.turn_left, // Biểu tượng
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _paintBoardKey.currentState!.ctrlY();
                            },
                            icon: Icon(
                              Icons.turn_right, // Biểu tượng
                              color: Colors.black,
                              size: 35, // Màu của biểu tượng
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
      ],
    ));
  }
}

class PaintBoard extends StatefulWidget {
  final GlobalKey<_PaintBoardState> key;
  final String chose;
  final Color paintColor;
  final double paintSize;
  final double height;
  final double width;
  PaintBoard(
      {required this.key,
      required this.chose,
      required this.height,
      required this.width,
      required this.paintColor,
      required this.paintSize});
  @override
  _PaintBoardState createState() => _PaintBoardState();
}

class _PaintBoardState extends State<PaintBoard> {
  late List<List<Offset>> points = [];
  late List<Paint> paints = [];
  late List<Offset> tmp = [];
  late Queue<List<Offset>> Qpn = Queue<List<Offset>>();
  late Queue<Paint> Qpt = Queue<Paint>();
  bool isInBox(Offset point) {
    if (point != null) {
      return point.dx >= 0 &&
          point.dy >= 0 &&
          point.dx <= widget.width &&
          point.dy <= widget.height;
    }
    return false;
  }

  Offset setValid(Offset point) {
    double x = point.dx, y = point.dy;
    if (point.dx < 0) x = 0;
    if (point.dy < 0) y = 0;
    if (point.dx > widget.width - 2) x = widget.width - 2;
    if (point.dy > widget.height - 2) y = widget.height - 2;
    Offset res = new Offset(x, y);
    return res;
  }

  void clearPoints() {
    setState(() {
      points.clear();
      tmp.clear();
      paints.clear();
    });
  }

  void ctrlZ() {
    setState(() {
      if (points.length <= 0) return;
      if (paints.length <= 0) return;
      Qpn.add(points[points.length - 1]);
      Qpt.add(paints[paints.length - 1]);
      points.removeLast();
      paints.removeLast();
    });
  }

  void ctrlY() {
    setState(() {
      if (Qpt.isEmpty || Qpt.length <= 0) return;
      if (Qpn.isEmpty || Qpn.length <= 0) return;
      points.add(Qpn.last);
      paints.add(Qpt.last);
      Qpn.removeLast();
      Qpt.removeLast();
      print("Ctrl + Y");
    });
  }

  @override
  Widget build(BuildContext context) {
    String chose = widget.chose;
    return GestureDetector(
      onPanDown: (DragDownDetails details) {
        setState(() {
          if (chose == "Fill") {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            // points[cnt].add(Offset(-1, -1));
          } else {
            Paint paint = Paint()
              ..color = widget.paintColor
              ..strokeCap = StrokeCap.round
              ..strokeWidth = widget.paintSize;
            paints.add(paint);
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset pos = renderBox.globalToLocal(details.globalPosition);
            // points[cnt].add(setValid(pos));
            tmp.add(setValid(pos));
            Qpn.clear();
            Qpt.clear();
          }
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          if (chose == "Draw") {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset pos = renderBox.globalToLocal(details.globalPosition);
            tmp.add(setValid(pos));
            // points[cnt].add(setValid(pos));
          }
        });
      },
      onPanEnd: (DragEndDetails details) {
        // if(chose == "Draw")
        setState(() {
          tmp.add(Offset(-1, -1));
          points.add(List.of(tmp));
          tmp.clear();
        });

        // points[cnt].add(Offset(-1, -1));
      },
      child: CustomPaint(
        painter: PaintCanvas(points: points, tmp: tmp, paints: paints),
        size: Size.infinite,
      ),
    );
  }
}

class PaintCanvas extends CustomPainter {
  final List<List<Offset>> points;
  final List<Offset> tmp;
  final List<Paint> paints;
  PaintCanvas({required this.points, required this.tmp, required this.paints});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length; i++) {
      for (int j = 0; j < points[i].length - 1; j++) {
        if (points[i][j] != null &&
            points[i][j + 1] != null &&
            points[i][j].dx != -1 &&
            points[i][j + 1].dx != -1) {
          canvas.drawLine(points[i][j], points[i][j + 1], paints[i]);
        }
      }
    }
    Paint paint2 = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;
    for (int j = 0; j < tmp.length - 1; j++) {
      if (tmp[j] != null &&
          tmp[j + 1] != null &&
          tmp[j].dx != -1 &&
          tmp[j + 1].dx != -1) {
        canvas.drawLine(tmp[j], tmp[j + 1], paints[paints.length - 1]);
      }
    }
  }

  @override
  bool shouldRepaint(PaintCanvas oldDelegate) => true;
}
