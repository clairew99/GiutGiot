import 'package:flutter/material.dart';
import 'dart:math';

class MotionButton extends StatefulWidget {
  @override
  _MotionButtonState createState() => _MotionButtonState();
}

class _MotionButtonState extends State<MotionButton> with SingleTickerProviderStateMixin {
  Offset _buttonPosition = Offset.zero; // 버튼의 현재 위치. 초기값 (0,0)
  String? _selectedItem;
  String? _selectedColorName;
  Color? _selectedColor;
  String? _selectedClothingTypeName;
  String? _selectedPatternName;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isSelectingColor = false; // 색상 선택 단계
  bool _isSelectingType = false; // 타입 선택 단계
  bool _isSelectingPattern = false; // 패턴 선택 단계
  bool _isSelectionComplete = false; // 선택 완료 상태

  List<Map<String, dynamic>> _colors = [
    {"name": "Yellow", "color": Color(0xFFFFFF00)},
    {"name": "Ivory", "color": Color(0xFFFFFFF0)},
    {"name": "Khaki", "color": Color(0xFF63C284)},
    {"name": "Light Blue", "color": Color(0xFFB6F7FA)},
    {"name": "Sky Blue", "color": Color(0xFF87CEEB)},
    {"name": "Navy", "color": Color(0xFF000080)},
    {"name": "Purple", "color": Color(0xFF800080)},
    {"name": "Lavender", "color": Color(0xFFF3BFFF)},
    {"name": "Brown", "color": Color(0xFFA52A2A)},
    {"name": "Black", "color": Color(0xFF000000)},
    {"name": "White", "color": Color(0xFFFFFFFF)},
    {"name": "Gray", "color": Color(0xFF808080)},
    {"name": "Red", "color": Color(0xFFF23D55)},
    {"name": "Pink", "color": Color(0xFFFFC0CB)},
    {"name": "Orange", "color": Color(0xFFFFA500)},
  ];

  final Map<String, String> _items = {
    "반팔": 'assets/test_icon/upclothes.png',
    "긴팔": 'assets/test_icon/long_upclothes.png',
    "반바지": 'assets/test_icon/downclothes.png',
    "긴바지": 'assets/test_icon/short_downclothes.png',
  };

  final Map<String, List<Map<String, String>>> _clothingTypes = {
    "상의": [
      {"name": "니트", "icon": 'assets/test_icon/top/knit.webp'},
      {"name": "셔츠", "icon": 'assets/test_icon/top/shirt.webp'},
      {"name": "반팔티", "icon": 'assets/test_icon/top/muji.webp'},
      {"name": "맨투맨", "icon": 'assets/test_icon/top/mujiTshirt.webp'},
      {"name": "카라셔츠", "icon": 'assets/test_icon/top/shirt2.webp'},
    ],
    "하의": [
      {"name": "청바지", "icon": 'assets/test_icon/bottom/p_jean.png'},
      {"name": "면바지", "icon": 'assets/test_icon/bottom/p_cotton.png'},
      {"name": "슬랙스", "icon": 'assets/test_icon/bottom/p_slacks.png'},
      {"name": "치마", "icon": 'assets/test_icon/bottom/skirt.png'},
      {"name": "카고바지", "icon": 'assets/test_icon/bottom/p_cargo.png'},
      {"name": "트레이닝", "icon": 'assets/test_icon/bottom/p_training.png'},
    ],
  };

  final List<Map<String, String>> _patterns = [
    {"name": "땡땡이", "icon": 'assets/test_icon/pattern/dot.webp'},
    {"name": "꽃무늬", "icon": 'assets/test_icon/pattern/flower.webp'},
    {"name": "민무늬", "icon": 'assets/test_icon/pattern/muji.webp'},
    {"name": "줄무늬", "icon": 'assets/test_icon/pattern/stripe.webp'},
    {"name": "체크", "icon": 'assets/test_icon/pattern/check.webp'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500), // 애니메이션 속도 조정
      vsync: this,
    );
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _buttonPosition = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetButtonPosition() {
    setState(() {
      _buttonPosition = Offset.zero;
      _controller.reset();
      _animation = Tween<Offset>(begin: _buttonPosition, end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward();
    });
  }

  void _updateButtonPosition(DragUpdateDetails details) {
    setState(() {
      _buttonPosition += Offset(details.delta.dx / 100, details.delta.dy / 100);
      if (_buttonPosition.dx > 1.0) _buttonPosition = Offset(1.0, _buttonPosition.dy);
      if (_buttonPosition.dx < -1.0) _buttonPosition = Offset(-1.0, _buttonPosition.dy);
      if (_buttonPosition.dy > 1.0) _buttonPosition = Offset(_buttonPosition.dx, 1.0);
      if (_buttonPosition.dy < -1.0) _buttonPosition = Offset(_buttonPosition.dx, -1.0);
    });
  }

  void _onButtonEnd() {
    if (_isSelectingColor) {
      bool colorSelected = false;
      for (int i = 0; i < _colors.length; i++) {
        final angle = 2 * pi / _colors.length * i;
        final x = cos(angle);
        final y = sin(angle);
        if ((_buttonPosition - Offset(x, y)).distance < 0.2) {
          _selectedColor = _colors[i]["color"];
          _selectedColorName = _colors[i]["name"];
          print("선택한 색상: $_selectedColorName");
          colorSelected = true;
          break;
        }
      }
      if (!colorSelected) {
        // 색상이 선택되지 않으면 경고 메시지를 표시하고 버튼 위치 초기화
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('색상을 선택해주세요.')),
        );
        _resetButtonPosition();
        return;
      }

      setState(() {
        _isSelectingColor = false;
        _isSelectingType = true;
        _resetButtonPosition();
      });
    } else if (_isSelectingType) {
      bool typeSelected = false;
      for (int i = 0; i < (_selectedItem == "반팔" || _selectedItem == "긴팔" ? _clothingTypes["상의"] : _clothingTypes["하의"])!.length; i++) {
        final angle = 2 * pi / (_selectedItem == "반팔" || _selectedItem == "긴팔" ? _clothingTypes["상의"] : _clothingTypes["하의"])!.length * i;
        final x = cos(angle);
        final y = sin(angle);
        if ((_buttonPosition - Offset(x, y)).distance < 0.2) {
          _selectedClothingTypeName = (_selectedItem == "반팔" || _selectedItem == "긴팔" ? _clothingTypes["상의"] : _clothingTypes["하의"])![i]["name"];
          print("선택한 타입: $_selectedClothingTypeName");
          typeSelected = true;
          break;
        }
      }
      if (!typeSelected) {
        // 타입이 선택되지 않으면 경고 메시지를 표시하고 버튼 위치 초기화
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('타입을 선택해주세요.')),
        );
        _resetButtonPosition();
        return;
      }

      setState(() {
        _isSelectingType = false;
        _isSelectingPattern = true;
        _resetButtonPosition();
      });
    } else if (_isSelectingPattern) {
      bool patternSelected = false;
      for (int i = 0; i < _patterns.length; i++) {
        final angle = 2 * pi / _patterns.length * i;
        final x = cos(angle);
        final y = sin(angle);
        if ((_buttonPosition - Offset(x, y)).distance < 0.2) {
          _selectedPatternName = _patterns[i]["name"];
          print("선택한 패턴: $_selectedPatternName");
          patternSelected = true;
          break;
        }
      }
      if (!patternSelected) {
        // 패턴이 선택되지 않으면 경고 메시지를 표시하고 버튼 위치 초기화
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('패턴을 선택해주세요.')),
        );
        _resetButtonPosition();
        return;
      }

      setState(() {
        _isSelectingPattern = false;
        _isSelectionComplete = true;
        _resetButtonPosition();
      });
    } else if (!_isSelectionComplete) {
      bool itemSelected = false;
      if (_buttonPosition.dy <= -0.9) {
        _selectedItem = "반팔";
        itemSelected = true;
      } else if (_buttonPosition.dy >= 0.9) {
        _selectedItem = "긴바지";
        itemSelected = true;
      } else if (_buttonPosition.dx <= -0.9) {
        _selectedItem = "긴팔";
        itemSelected = true;
      } else if (_buttonPosition.dx >= 0.9) {
        _selectedItem = "반바지";
        itemSelected = true;
      }

      if (!itemSelected) {
        // 종류가 선택되지 않으면 경고 메시지를 표시하고 버튼 위치 초기화
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('종류를 선택해주세요.')),
        );
        _resetButtonPosition();
        return;
      }

      print("선택한 종류: $_selectedItem");

      setState(() {
        _isSelectingColor = true;
        _resetButtonPosition();
      });
    }
  }

  Widget _buildSelectionResult() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '선택한 항목',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '종류: $_selectedItem',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '색상: $_selectedColorName',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '타입: $_selectedClothingTypeName',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '패턴: $_selectedPatternName',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple[50],
          ),
        ),
        if (_isSelectingColor)
          ..._buildColorButtons(),
        if (!_isSelectingColor && !_isSelectingType && !_isSelectingPattern && !_isSelectionComplete)
          ..._buildItemButtons(),
        if (_isSelectingType)
          ..._buildTypeButtons(),
        if (_isSelectingPattern)
          ..._buildPatternButtons(),
        if (_isSelectionComplete)
          _buildSelectionResult(),
        if (!_isSelectionComplete)
          GestureDetector(
            onTap: _onButtonEnd,
            onPanUpdate: _updateButtonPosition,
            onPanEnd: (_) => _onButtonEnd(),
            child: Transform.translate(
              offset: Offset(_buttonPosition.dx * 100, _buttonPosition.dy * 100),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue[200]!, Colors.purple[100]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 종류 선택 버튼
  List<Widget> _buildItemButtons() {
    return [
      Positioned(
        top: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedItem = "반팔";
              _isSelectingColor = true;
              _resetButtonPosition();
            });
          },
          child: Image.asset(
            'assets/test_icon/upclothes.png',
            width: 80,
            height: 80,
          ),
        ),
      ),
      Positioned(
        right: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedItem = "반바지";
              _isSelectingColor = true;
              _resetButtonPosition();
            });
          },
          child: Image.asset(
            'assets/test_icon/short_downclothes.png',
            width: 80,
            height: 80,
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedItem = "긴바지";
              _isSelectingColor = true;
              _resetButtonPosition();
            });
          },
          child: Image.asset(
            'assets/test_icon/downclothes.png',
            width: 80,
            height: 80,
          ),
        ),
      ),
      Positioned(
        left: 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedItem = "긴팔";
              _isSelectingColor = true;
              _resetButtonPosition();
            });
          },
          child: Image.asset(
            'assets/test_icon/long_upclothes.png',
            width: 80,
            height: 80,
          ),
        ),
      ),
    ];
  }

  // 색상 선택 버튼
  List<Widget> _buildColorButtons() {
    final double radius = 120.0;
    final double angleStep = 2 * pi / _colors.length;

    return List.generate(_colors.length, (index) {
      final double angle = angleStep * index;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      return Positioned(
        left: x + 160 - 15,
        top: y + 160 - 15,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = _colors[index]["color"];
              _selectedColorName = _colors[index]["name"];
              _isSelectingColor = false;
              _isSelectingType = true;
              _resetButtonPosition();
            });
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _colors[index]["color"],
            ),
          ),
        ),
      );
    });
  }

  // 타입 선택
  List<Widget> _buildTypeButtons() {
    final double radius = 60.0;
    final List<Map<String, String>> types = (_selectedItem == "반팔" || _selectedItem == "긴팔") ? _clothingTypes["상의"]! : _clothingTypes["하의"]!;
    final double angleStep = 2 * pi / types.length;

    return List.generate(types.length, (index) {
      final double angle = angleStep * index;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      return Positioned(
        left: x + 160 - 35,
        top: y + 160 - 35,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedClothingTypeName = types[index]["name"];
              _isSelectingType = false;
              _isSelectingPattern = true;
              _resetButtonPosition();
            });
          },
          child: Transform.translate(
            offset: Offset(x, y),
            child: Image.asset(
              types[index]["icon"]!,
              width: 70,
              height: 70,
            ),
          ),
        ),
      );
    });
  }


  // 패턴 선택
  List<Widget> _buildPatternButtons() {
    final double radius = 120.0;
    final double angleStep = 2 * pi / _patterns.length;

    return List.generate(_patterns.length, (index) {
      final double angle = angleStep * index;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      return Positioned(
        left: x + 160 - 35,
        top: y + 160 - 35,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedPatternName = _patterns[index]["name"];
              _isSelectingPattern = false;
              _isSelectionComplete = true;
              _resetButtonPosition();
            });
          },
          child: Image.asset(
            _patterns[index]["icon"]!,
            width: 70,
            height: 70,
          ),
        ),
      );
    });
  }
}
