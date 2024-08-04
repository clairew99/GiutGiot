import 'package:flutter/material.dart';

class NicknameChangeDialog extends StatefulWidget {
  final String currentNickname;
  final ValueChanged<String> onNicknameChanged;

  NicknameChangeDialog({
    Key? key,
    required this.currentNickname,
    required this.onNicknameChanged,
  }) : super(key: key);

  @override
  _NicknameChangeDialogState createState() => _NicknameChangeDialogState();
}

class _NicknameChangeDialogState extends State<NicknameChangeDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentNickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // 모서리 둥글게
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%로 설정
        padding: EdgeInsets.all(20.0), // 여백 추가
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('닉네임 변경', textAlign: TextAlign.center ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '새 닉네임',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('취소'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onNicknameChanged(_controller.text);
                    Navigator.of(context).pop();
                  },
                  child: Text('변경'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
