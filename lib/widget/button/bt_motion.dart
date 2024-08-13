import 'package:GIUTGIOT/utils/clothes/controller/clothes_controller.dart';
import 'package:GIUTGIOT/utils/clothes/dto/request_cloth_dto.dart';
import 'package:GIUTGIOT/utils/clothes/dto/request_today_clothes_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../../utils/clothes/clothes_request_manager.dart';

class MotionButton extends StatefulWidget {
  final VoidCallback onSelectionComplete;


  MotionButton({required this.onSelectionComplete});

  @override
  _MotionButtonState createState() => _MotionButtonState();
}

class _MotionButtonState extends State<MotionButton> with SingleTickerProviderStateMixin {
  final clothesController = Get.find<ClothesController>();
  Offset _buttonPosition = Offset.zero;
  String? _selectedItem;
  String? _selectedColorName;
  Color? _selectedColor;
  String? _selectedClothingTypeName;
  String? _selectedPatternName;
  String? _firstSelectedItem;
  String? _firstSelectedColorName;
  Color? _firstSelectedColor;
  String? _firstSelectedClothingTypeName;
  String? _firstSelectedPatternName;
  bool _isFirstChoiceComplete = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isSelectingColor = false;
  bool _isSelectingType = false;
  bool _isSelectingPattern = false;
  bool _isSelectionComplete = false;

  List<Map<String, dynamic>> _colors = [
    {"name": "YELLOW", "color": Color(0xFFFFFF00)},
    {"name": "IVORY", "color": Color(0xFFFFFFF0)},
    {"name": "GREEN", "color": Color(0xFF63C284)},
    {"name": "SKYBLUE", "color": Color(0xFFB6F7FA)},
    {"name": "BLUE", "color": Color(0xFF87CEEB)},
    {"name": "NAVY", "color": Color(0xFF000080)},
    {"name": "PURPLE", "color": Color(0xFF800080)},
    {"name": "LAVENDER", "color": Color(0xFFF3BFFF)},
    {"name": "BROWN", "color": Color(0xFFA52A2A)},
    {"name": "BLACK", "color": Color(0xFF000000)},
    {"name": "WHITE", "color": Color(0xFFFFFFFF)},
    {"name": "GRAY", "color": Color(0xFF808080)},
    {"name": "RED", "color": Color(0xFFF23D55)},
    {"name": "PINK", "color": Color(0xFFFFC0CB)},
    {"name": "ORANGE", "color": Color(0xFFFFA500)},
  ];

  final Map<String, String> _items = {
    "반팔": 'assets/test_icon/upclothes.png',
    "긴팔": 'assets/test_icon/long_upclothes.png',
    "반바지": 'assets/test_icon/downclothes.png',
    "긴바지": 'assets/test_icon/short_downclothes.png',
  };

  final Map<String, List<Map<String, String>>> _clothingTypes = {
    "상의": [
      {"name": "KNIT", "icon": 'assets/test_icon/top/knit.webp'},
      {"name": "SHIRT", "icon": 'assets/test_icon/top/shirt.webp'},
      {"name": "COTTON", "icon": 'assets/test_icon/top/muji.webp'},
      {"name": "HOODIE", "icon": 'assets/test_icon/top/mujiTshirt.webp'},   // 맨투맨 -> 후디
      {"name": "COLLAR", "icon": 'assets/test_icon/top/shirt2.webp'},
    ],
    "하의": [
      {"name": "JEANS", "icon": 'assets/test_icon/bottom/p_jean.png'},
      {"name": "COTTON", "icon": 'assets/test_icon/bottom/p_cotton.png'},
      {"name": "SLACKS", "icon": 'assets/test_icon/bottom/p_slacks.png'},
      {"name": "SKIRT", "icon": 'assets/test_icon/bottom/skirt.png'},
      {"name": "CARGO", "icon": 'assets/test_icon/bottom/p_cargo.png'},
      {"name": "TRAINING", "icon": 'assets/test_icon/bottom/p_training.png'},
    ],
  };

  final List<Map<String, String>> _patterns = [
    {"name": "DOT", "icon": 'assets/test_icon/pattern/pattern_dot.png'},
    {"name": "FLOWER", "icon": 'assets/test_icon/pattern/pattern_flower.png'},
    {"name": "SOLID", "icon": 'assets/test_icon/pattern/pattern_muji.png'},
    {"name": "STRIPE", "icon": 'assets/test_icon/pattern/pattern_stripe.png'},
    {"name": "CHECK", "icon": 'assets/test_icon/pattern/pattern_check.png'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut))
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
      _animation = Tween<Offset>(
          begin: _buttonPosition, end: Offset.zero)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward();
    });
  }


  // 선택된 상하의 색상 저장
  void _saveSelectedColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTopColor', _firstSelectedColorName!);
    await prefs.setString('selectedBottomColor', _selectedColorName!);
    await clothesController.setSelectedClothesColor(_firstSelectedColorName!, _selectedColorName!);


    // 오늘 날짜의 옷 색상을 전송하고, 그 반환값을 다시 서버로 전송해야함
    final topType = _firstSelectedItem == '긴팔' ? 'LONG' : 'SHORT';
    final bottomType = _selectedItem == '긴바지' ? 'LONG' : 'SHORT';
    final topClothes = RequestClothesDto(isTop: true,color: _firstSelectedColorName,type: topType, category: _firstSelectedClothingTypeName,pattern: _firstSelectedPatternName);
    final bottomClothes = RequestClothesDto(isTop: false,color: _selectedColorName,type: bottomType, category: _selectedClothingTypeName,pattern: _selectedPatternName);

    final topId =  await saveClothes(topClothes);
    final bottomId =  await saveClothes(bottomClothes);
    final now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final requestTodayClothesDto = RequestTodayClothesDto(topId: topId,bottomId: bottomId,date: formattedDate);
    await saveTodayClothes(requestTodayClothesDto);
    await clothesController.getCurrentClothes(clothesController.baseDate.value.add(Duration(days: 6)));
    print('색상 선택 완료: 상의 - $_firstSelectedColorName, 하의 - $_selectedColorName');
  }



  void _onButtonEnd() {
    if (_isSelectingColor) {
      bool colorSelected = false;
      for (int i = 0; i < _colors.length; i++) {
        final angle = 2 * pi / _colors.length * i;
        final x = cos(angle);
        final y = sin(angle);
        if ((_buttonPosition - Offset(x, y)).distance < 0.3) {
          _selectedColor = _colors[i]["color"];
          _selectedColorName = _colors[i]["name"];
          colorSelected = true;
          break;
        }
      }
      if (!colorSelected) {
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
      for (int i = 0; i < (_selectedItem == "반팔" || _selectedItem == "긴팔"
          ? _clothingTypes["상의"]
          : _clothingTypes["하의"])!.length;
      i++) {
        final angle = 2 * pi / (_selectedItem == "반팔" || _selectedItem == "긴팔"
            ? _clothingTypes["상의"]
            : _clothingTypes["하의"])!.length *
            i;
        final x = cos(angle);
        final y = sin(angle);
        if ((_buttonPosition - Offset(x, y)).distance < 0.3) {
          _selectedClothingTypeName = (_selectedItem == "반팔" || _selectedItem == "긴팔"
              ? _clothingTypes["상의"]
              : _clothingTypes["하의"])![i]["name"];
          typeSelected = true;
          break;
        }
      }
      if (!typeSelected) {
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
        if ((_buttonPosition - Offset(x, y)).distance < 0.3) {
          _selectedPatternName = _patterns[i]["name"];
          patternSelected = true;
          break;
        }
      }
      if (!patternSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('패턴을 선택해주세요.')),
        );
        _resetButtonPosition();
        return;
      }

      setState(() {
        _isSelectingPattern = false;
        _isSelectionComplete = true;
        if (_isFirstChoiceComplete) {
          _saveSelectedColors();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('선택이 완료되었습니다.')),
          );

          widget.onSelectionComplete(); // 선택 완료 후 콜백 호출

          // 상태 초기화
          _isFirstChoiceComplete = false;
          _selectedItem = null;
          _selectedColorName = null;
          _selectedColor = null;
          _selectedClothingTypeName = null;
          _selectedPatternName = null;
          _isSelectingColor = false;
          _isSelectingType = false;
          _isSelectingPattern = false;
          _isSelectionComplete = false;
          _resetButtonPosition();
        } else {
          _isFirstChoiceComplete = true;
          _firstSelectedItem = _selectedItem;
          _firstSelectedColorName = _selectedColorName;
          _firstSelectedColor = _selectedColor;
          _firstSelectedClothingTypeName = _selectedClothingTypeName;
          _firstSelectedPatternName = _selectedPatternName;
          _selectedItem = null;
          _selectedColorName = null;
          _selectedColor = null;
          _selectedClothingTypeName = null;
          _selectedPatternName = null;
          _isSelectingColor = false;
          _isSelectingType = false;
          _isSelectingPattern = false;
          _isSelectionComplete = false;
          _resetButtonPosition();
        }
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('종류를 선택해주세요.')),
        );
        _resetButtonPosition();
        return;
      }

      setState(() {
        _isSelectingColor = true;
        _resetButtonPosition();
      });
    }
  }

  // 모션버튼
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
            // color: Colors.purple[50],
            color: Colors.white.withOpacity(0.5),

          ),
        ),
        if (_isSelectingColor) ..._buildColorButtons(),
        if (!_isSelectingColor && !_isSelectingType && !_isSelectingPattern && !_isSelectionComplete) ..._buildItemButtons(),
        if (_isSelectingType) ..._buildTypeButtons(),
        if (_isSelectingPattern) ..._buildPatternButtons(),
        // if (_isSelectionComplete && _isFirstChoiceComplete) _buildSelectionResult(),
        if (!_isSelectionComplete)
          GestureDetector(
            onTap: () {
              _handleBackButton();
            },
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
                  child: _isSelectingColor || _isSelectingType || _isSelectingPattern
                      ? Icon(
                    Icons.arrow_back,
                    color: Colors.black.withOpacity(0.4),
                  )
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Widget _buildSelectionResult() {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Container(
  //       margin: EdgeInsets.only(bottom: 20),
  //       padding: EdgeInsets.all(10),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             '선택한 항목',
  //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //           ),
  //           Text(
  //             '상의: $_firstSelectedItem $_firstSelectedColorName $_firstSelectedClothingTypeName $_firstSelectedPatternName',
  //             style: TextStyle(fontSize: 18),
  //           ),
  //           Text(
  //             '하의: $_selectedItem $_selectedColorName $_selectedClothingTypeName $_selectedPatternName',
  //             style: TextStyle(fontSize: 18),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  List<Widget> _buildItemButtons() {
    final double radius = 110.0;
    final double angleStep = 2 * pi / 4;

    return List.generate(4, (index) {
      final double angle = angleStep * index;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      String itemType;
      String assetPath;
      bool isBlurred = false;

      switch (index) {
        case 0:
          itemType = "긴바지";
          assetPath = 'assets/test_icon/downclothes.png';
          isBlurred = !_isFirstChoiceComplete;
          break;
        case 1:
          itemType = "반바지";
          assetPath = 'assets/test_icon/short_downclothes.png';
          isBlurred = !_isFirstChoiceComplete;
          break;
        case 2:
          itemType = "긴팔";
          assetPath = 'assets/test_icon/long_upclothes.png';
          isBlurred = _isFirstChoiceComplete;
          break;
        case 3:
          itemType = "반팔";
          assetPath = 'assets/test_icon/upclothes.png';
          isBlurred = _isFirstChoiceComplete;
          break;
        default:
          itemType = "반팔";
          assetPath = 'assets/test_icon/upclothes.png';
          break;
      }

      return Positioned(
        left: x + 160 - 48,
        top: y + 160 - 50,
        child: GestureDetector(
          onTap: isBlurred ? null : () {
            if (!_isFirstChoiceComplete || (_firstSelectedItem != itemType)) {
              setState(() {
                _selectedItem = itemType;
                _isSelectingColor = true;
                _resetButtonPosition();
              });
            }
          },
          child: ColorFiltered(
            colorFilter: isBlurred
                ? ColorFilter.mode(Colors.grey.withOpacity(0.4), BlendMode.srcATop)
                : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
            child: Image.asset(
              assetPath,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );
    });
  }

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

  List<Widget> _buildTypeButtons() {
    final double radius = 110.0;
    final List<Map<String, String>> types = (_selectedItem == "반팔" || _selectedItem == "긴팔")
        ? _clothingTypes["상의"]!
        : _clothingTypes["하의"]!;
    final double angleStep = 2 * pi / types.length;

    return List.generate(types.length, (index) {
      final double angle = angleStep * index;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      return Positioned(
        left: x + 160 - 40,
        top: y + 160 - 45,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedClothingTypeName = types[index]["name"];
              _isSelectingType = false;
              _isSelectingPattern = true;
              _resetButtonPosition();
            });
          },
          child: Image.asset(
            types[index]["icon"]!,
            width: 80,
            height: 80,
          ),
        ),
      );
    });
  }

  List<Widget> _buildPatternButtons() {
    final double radius = 110.0;
    final double angleStep = 2 * pi / _patterns.length;

    return List.generate(_patterns.length, (index) {
      final double angle = angleStep * index;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      return Positioned(
        left: x + 160 - 25,
        top: y + 160 - 28,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedPatternName = _patterns[index]["name"];
              _isSelectingPattern = false;
              _isSelectionComplete = true;
              if (_isFirstChoiceComplete) {
                _saveSelectedColors();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('상의: $_firstSelectedItem $_firstSelectedColorName $_firstSelectedClothingTypeName $_firstSelectedPatternName, 하의: $_selectedItem $_selectedColorName $_selectedClothingTypeName $_selectedPatternName')),
                // );
                widget.onSelectionComplete(); // 선택 완료 후 콜백 호출
                _resetButtonPosition();
              } else {
                _isFirstChoiceComplete = true;
                _firstSelectedItem = _selectedItem;
                _firstSelectedColorName = _selectedColorName;
                _firstSelectedColor = _selectedColor;
                _firstSelectedClothingTypeName = _selectedClothingTypeName;
                _firstSelectedPatternName = _selectedPatternName;
                _selectedItem = null;
                _selectedColorName = null;
                _selectedColor = null;
                _selectedClothingTypeName = null;
                _selectedPatternName = null;
                _isSelectingColor = false;
                _isSelectingType = false;
                _isSelectingPattern = false;
                _isSelectionComplete = false;
                _resetButtonPosition();
              }
            });
          },
          child: Image.asset(
            _patterns[index]["icon"]!,
            width: 55,
            height: 55,
          ),
        ),
      );
    });
  }

  void _handleBackButton() {
    setState(() {
      if (_isSelectingPattern) {
        _isSelectingPattern = false;
        _isSelectingType = true;
      } else if (_isSelectingType) {
        _isSelectingType = false;
        _isSelectingColor = true;
      } else if (_isSelectingColor) {
        _isSelectingColor = false;
        _selectedItem = null;
      } else if (!_isFirstChoiceComplete) {
        _resetButtonPosition();
      }
    });
  }
}
