import 'dart:collection';
import 'dart:convert';

import 'package:draw_and_guess_promax/firebase.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:draw_and_guess_promax/provider/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Drawing extends ConsumerStatefulWidget {
  const Drawing({
    super.key,
    required this.height,
    required this.width,
    required this.selectedRoom,
  });

  final double height;
  final double width;
  final Room selectedRoom;

  @override
  ConsumerState<Drawing> createState() => _Drawing();
}

class _Drawing extends ConsumerState<Drawing> {
  late Offset _containerPosition;
  late bool _isSizeMenuVisible;
  late Offset _containerPositionSize;
  late bool _isSelectMenuVisible;
  late Color _paintColor;
  late Color _preColor;
  late bool _isErase;
  late double _paintSize;
  late IconData _selectIcon;
  late DatabaseReference _normalModeDataRef;
  late DatabaseReference _drawRef;
  bool? _isMenuBarVisible;
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
    _preColor = Colors.black;
    _paintSize = 5;
    _selectIcon = Icons.draw;
    _isSizeMenuVisible = false;
    _containerPositionSize = Offset.zero;
    _isErase = false;

    _drawRef = database.child('/draw/${widget.selectedRoom}');

    _normalModeDataRef =
        database.child('/normal_mode_data/${widget.selectedRoom.roomId}');
    _normalModeDataRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      print(data['turn']);
      setState(() {
        _isMenuBarVisible = data['turn'] == ref.read(userProvider).id;
      });
    });
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
    if (_isErase) return;
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

  void _setChose(String mode) {
    setState(() {
      chose = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const Color mainColor = Color(0xFF00C4A1);
    const double sizePickColor = 22;

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
                height: widget.height,
                width: widget.width,
                child: PaintBoard(
                    key: _paintBoardKey,
                    chose: chose,
                    paintColor: _paintColor,
                    paintSize: _paintSize,
                    height: widget.height,
                    width: widget.width,
                    selectedRoom: widget.selectedRoom,
                    hideMenu: () {
                      _toggleSelectMenuVisibility(Offset.zero);
                      _toggleSizeMenuVisibility(Offset.zero);
                    }),
              ))
            ],
          ),
        ),
        // ----------------------  MenuBar ----------------------
        if (_isMenuBarVisible == true)
          Positioned(
            top: widget.height - 100,
            left: 0,
            child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                height: 100,
                width: size.width,
                color: mainColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectIcon != Icons.add &&
                        _selectIcon != Icons.minimize)
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
                              _setColor(
                                  Theme.of(context).scaffoldBackgroundColor);
                              _setSelectIcon(Icons.add);
                              RenderBox buttonBox = _selectmenu.currentContext!
                                  .findRenderObject() as RenderBox;
                              Offset buttonPosition =
                                  buttonBox.localToGlobal(Offset.zero);
                              _toggleSelectMenuVisibility(buttonPosition);
                            },
                            child: Image.asset(
                              'assets/images/erase.png',
                              // Đường dẫn đến hình ảnh cục tẩy
                              width: 10,
                              height: 10,
                              color: Colors.black, // Màu của hình ảnh
                            ),
                          )),
                    if (_selectIcon == Icons.minimize)
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
                              _setColor(
                                  Theme.of(context).scaffoldBackgroundColor);
                              _setSelectIcon(Icons.minimize);
                              RenderBox buttonBox = _selectmenu.currentContext!
                                  .findRenderObject() as RenderBox;
                              Offset buttonPosition =
                                  buttonBox.localToGlobal(Offset.zero);
                              _toggleSelectMenuVisibility(buttonPosition);
                            },
                            child: Image.asset(
                              'assets/images/draw_line.png',
                              // Đường dẫn đến hình ảnh cục tẩy
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
                        icon: const Icon(
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
                        color: const Color.fromRGBO(255, 205, 234, 1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (final color in [
                                Colors.black,
                                Colors.white,
                                Colors.grey,
                                Colors.red,
                                Colors.yellow,
                                Colors.green,
                                Colors.blue
                              ])
                                SizedBox(
                                  height: sizePickColor,
                                  width: sizePickColor,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _setColor(color);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(
                                            sizePickColor, sizePickColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Border radius là 5
                                        ),
                                        backgroundColor: color),
                                    child: const SizedBox(
                                      width: sizePickColor,
                                      // Kích thước của hình vuông
                                      height: sizePickColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (final color in [
                                Colors.pink,
                                Colors.brown,
                                Colors.cyanAccent,
                                Colors.greenAccent,
                                Colors.orange,
                                Colors.purple,
                                Colors.teal
                              ])
                                SizedBox(
                                  height: sizePickColor,
                                  width: sizePickColor,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _setColor(color);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(
                                            sizePickColor, sizePickColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Border radius là 5
                                        ),
                                        backgroundColor: color),
                                    child: const SizedBox(
                                      width: sizePickColor,
                                      // Kích thước của hình vuông
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
                      margin: const EdgeInsets.all(5.0),
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
                        icon: const Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 10,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.all(5.0),
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
                        icon: const Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 15,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.all(5.0),
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
                        icon: const Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 20,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.all(5.0),
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
                        icon: const Icon(
                          Icons.circle_outlined, // Biểu tượng
                          color: Colors.black, // Màu của biểu tượng
                          size: 25,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.all(5.0),
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
                        icon: const Icon(
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
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: IconButton(
                            onPressed: () {
                              _paintBoardKey.currentState!.clearPoints();
                              _isErase = false;
                            },
                            icon: const Icon(
                              Icons.delete, // Biểu tượng
                              color: Colors.black, // Màu của biểu tượng
                              size: 35,
                            ),
                          ),
                        ),
                        Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  7.0), // Bán kính cong của đường viền
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  _preColor = _paintColor;
                                  _setColor(Theme.of(context)
                                      .scaffoldBackgroundColor);
                                  _setSelectIcon(Icons.add);
                                  _toggleSelectMenuVisibility(
                                      const Offset(0, 0));
                                  _isErase = true;
                                },
                                child: Image.asset('assets/images/erase.png')
                                // Image.asset(
                                //   'assets/images/erase.png', // Đường dẫn đến hình ảnh cục tẩy
                                //   width: 10,
                                //   height: 10,
                                //   color: Colors.black, // Màu của hình ảnh
                                // ),
                                )),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: IconButton(
                            onPressed: () {
                              _isErase = false;
                              _setSelectIcon(Icons.draw);
                              _toggleSelectMenuVisibility(const Offset(0, 0));
                              _setColor(_preColor);
                              _setChose("Draw");
                            },
                            icon: const Icon(
                              Icons.draw, // Biểu tượng
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: GestureDetector(
                              onTap: () {
                                _setSelectIcon(Icons.minimize);
                                _toggleSelectMenuVisibility(const Offset(0, 0));
                                _setChose("DrawLine");
                              },
                              child: Image.asset(
                                'assets/images/draw_line.png',
                                width: 20,
                                height: 20,
                              )
                              // Image.asset(
                              //   'assets/images/erase.png', // Đường dẫn đến hình ảnh cục tẩy
                              //   width: 10,
                              //   height: 10,
                              //   color: Colors.black, // Màu của hình ảnh
                              // ),
                              ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                7.0), // Bán kính cong của đường viền
                          ),
                          child: IconButton(
                            onPressed: () {
                              _paintBoardKey.currentState!.ctrlZ();
                            },
                            icon: const Icon(
                              Icons.turn_left, // Biểu tượng
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _paintBoardKey.currentState!.ctrlY();
                            },
                            icon: const Icon(
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

class PaintBoard extends ConsumerStatefulWidget {
  final GlobalKey<_PaintBoardState> key;
  final String chose;
  final Color paintColor;
  final double paintSize;
  final double height;
  final double width;
  final Room selectedRoom;
  final void Function() hideMenu;

  PaintBoard(
      {required this.key,
      required this.chose,
      required this.height,
      required this.width,
      required this.paintColor,
      required this.paintSize,
      required this.selectedRoom,
      required this.hideMenu});

  @override
  _PaintBoardState createState() => _PaintBoardState();
}

class _PaintBoardState extends ConsumerState<PaintBoard> {
  late List<List<Offset>> points = [];
  late List<Paint> paints = [];
  late List<Offset> tmp = [];
  late Queue<List<Offset>> Qpn = Queue<List<Offset>>();
  late Queue<Paint> Qpt = Queue<Paint>();
  late bool isDrawLine = false;
  late DatabaseReference drawRef;
  late DatabaseReference _normalModeDataRef;
  late DatabaseReference _myDataRef;
  late DatabaseReference _myAlbumRef;
  var userTurn = "";

  @override
  initState() {
    super.initState();
    // setup cho chế độ thường
    if (widget.selectedRoom.mode == 'Thường') {
      drawRef = database.child('/draw/${widget.selectedRoom.roomId}');
      _normalModeDataRef =
          database.child('/normal_mode_data/${widget.selectedRoom.roomId}');

      _normalModeDataRef.onValue.listen((event) {
        final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>,
        );
        setState(() {
          userTurn = data['turn'];
        });

        // Xóa bảng khi có người đoán đúng
        final timeLeft = data['timeLeft'];
        if (timeLeft == 60) {
          clearPoints();
        }
        // Ẩn menu khi có người đoán đúng
        widget.hideMenu();
      });

      drawRef.onValue.listen((event) async {
        // Khi có sự thay đổi dữ liệu trên Firebase
        if (event.snapshot.value == null) {
          clearPoints();
        }

        if (userTurn != ref.read(userProvider).id) {
          if (event.snapshot.value is Map) {
            final data = (event.snapshot.value as Map).map((key, value) {
              return MapEntry(key.toString(), value.toString());
            });
            setState(() {
              points = decodeOffsetList(data["Offset"]!);
              paints = decodePaintList(data["Color"]!);
            });
          }
        }
      });
    }

    // setup cho chế độ tam sao thất bản
    if (widget.selectedRoom.mode == 'Tam sao thất bản') {
      _myDataRef = database.child(
          '/kickoff_mode_data/${widget.selectedRoom.roomId}/${ref.read(userProvider).id}');
      _myAlbumRef = _myDataRef.child('/album');

      _myDataRef.onValue.listen((event) {
        final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>,
        );
        var timeLeft = data['timeLeft'];
        /*var album = Map<String, dynamic>.from(
            data['album'] as Map<dynamic, dynamic>,
          );*/
        if (timeLeft == 0) {
          // TODO send data to firebase one time
          _myDataRef.update({'timeLeft': -1});
          updatePointsKickoffMode();
          clearPoints();
        }
      });
    }

    // setup cho chế độ tuyệt tác
    if (widget.selectedRoom.mode == 'Tuyệt tác') {}
  }

  bool isInBox(Offset point) {
    return point.dx >= 0 &&
        point.dy >= 0 &&
        point.dx <= widget.width &&
        point.dy <= widget.height;
  }

  Offset setValid(Offset point) {
    double x = point.dx, y = point.dy;
    if (point.dx < 0) x = 0;
    if (point.dy < 0) y = 0;
    if (point.dx > widget.width - 2) x = widget.width - 2;
    if (point.dy > widget.height - 2) y = widget.height - 2;
    Offset res = Offset(x, y);
    return res;
  }

  void clearPoints() {
    setState(() {
      points.clear();
      tmp.clear();
      paints.clear();
      updatePointsNormalMode();
    });
  }

  void ctrlZ() {
    setState(() {
      if (points.isEmpty) return;
      if (paints.isEmpty) return;
      Qpn.add(points[points.length - 1]);
      Qpt.add(paints[paints.length - 1]);
      points.removeLast();
      paints.removeLast();

      updatePointsNormalMode();
    });
  }

  void ctrlY() {
    setState(() {
      if (Qpt.isEmpty || Qpt.isEmpty) return;
      if (Qpn.isEmpty || Qpn.isEmpty) return;
      points.add(Qpn.last);
      paints.add(Qpt.last);
      Qpn.removeLast();
      Qpt.removeLast();
      print("Ctrl + Y");

      updatePointsNormalMode();
    });
  }

  String encodeOffsetList(List<List<Offset>> offsetList) {
    List<List<double>> encodedList = [];
    for (var innerList in offsetList) {
      List<double> tempList = [];
      for (var offset in innerList) {
        tempList.add(offset.dx);
        tempList.add(offset.dy);
      }
      encodedList.add(tempList);
    }
    return json.encode(encodedList);
  }

// Hàm decode chuỗi JSON thành List<List<Offset>>
  List<List<Offset>> decodeOffsetList(String jsonStr) {
    List<List<Offset>> offsetList = [];

    if (jsonStr.isNotEmpty) {
      // Decode the JSON string
      List<dynamic> decodedList = json.decode(jsonStr);

      // Process each inner list
      for (var innerList in decodedList) {
        if (innerList is List) {
          List<Offset> tempList = [];
          for (int i = 0; i < innerList.length; i += 2) {
            tempList.add(
                Offset(innerList[i] as double, innerList[i + 1] as double));
          }
          offsetList.add(tempList);
        }
      }
    }

    return offsetList;
  }

  String encodePaintList(List<Paint> paintList) {
    List<Map<String, dynamic>> encodedList = paintList.map((paint) {
      return {
        'color': paint.color.value,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
        'isAntiAlias': paint.isAntiAlias,
        // Add other properties if needed
      };
    }).toList();
    return json.encode(encodedList);
  }

// Hàm decode chuỗi JSON thành List<Paint>
  List<Paint> decodePaintList(String jsonStr) {
    List<Map<String, dynamic>> decodedList =
        List<Map<String, dynamic>>.from(json.decode(jsonStr));
    return decodedList.map((paintMap) {
      Paint paint = Paint()
        ..color = Color(paintMap['color'])
        ..strokeWidth = paintMap['strokeWidth']
        ..style = PaintingStyle.values[paintMap['style']]
        ..isAntiAlias = paintMap['isAntiAlias'];
      // Add other properties if needed
      return paint;
    }).toList();
  }

  void updatePointsNormalMode() async {
    List<List<Offset>> fbpush = points;
    if (tmp.isNotEmpty) fbpush.add(tmp);

    await drawRef.update(
        {'Offset': encodeOffsetList(fbpush), 'Color': encodePaintList(paints)});
  }

  void updatePointsKickoffMode() async {
    if (points.isEmpty && tmp.isEmpty) return;
    List<List<Offset>> fbpush = points;
    if (tmp.isNotEmpty) fbpush.add(tmp);

    await _myAlbumRef.push().update(
        {'Offset': encodeOffsetList(fbpush), 'Color': encodePaintList(paints)});
  }

  void getData() {}

  @override
  Widget build(BuildContext context) {
    String chose = widget.chose;
    return GestureDetector(
      onPanDown: (DragDownDetails details) {
        if (userTurn != ref.read(userProvider).id) return;

        setState(() {
          if (chose == "Fill") {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
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
            //updatePointsNormalMode();

            Qpn.clear();
            Qpt.clear();
          }
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (userTurn != ref.read(userProvider).id) return;

        setState(() {
          if (chose == "Draw") {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset pos = renderBox.globalToLocal(details.globalPosition);
            tmp.add(setValid(pos));
            //updatePointsNormalMode();
            // points[cnt].add(setValid(pos));
          } else if (chose == "DrawLine") {
            if (tmp.length > 1) tmp.removeLast();
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset pos = renderBox.globalToLocal(details.globalPosition);
            tmp.add(setValid(pos));
            //updatePointsNormalMode();
          }
        });
      },
      onPanEnd: (DragEndDetails details) {
        if (userTurn != ref.read(userProvider).id) return;

        // if(chose == "Draw")
        setState(() {
          tmp.add(const Offset(-1, -1));
          points.add(List.of(tmp));
          tmp.clear();
          updatePointsNormalMode();
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
        if (points[i][j].dx != -1 && points[i][j + 1].dx != -1) {
          canvas.drawLine(points[i][j], points[i][j + 1], paints[i]);
        }
      }
    }
    Paint paint2 = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;
    for (int j = 0; j < tmp.length - 1; j++) {
      if (tmp[j].dx != -1 && tmp[j + 1].dx != -1) {
        canvas.drawLine(tmp[j], tmp[j + 1], paints[paints.length - 1]);
      }
    }
  }

  @override
  bool shouldRepaint(PaintCanvas oldDelegate) => true;
}
