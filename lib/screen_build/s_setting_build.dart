import 'package:flutter/material.dart';

import '../widget/box/b_content_opacity.dart';
import '../widget/modal/w_nickname_modal.dart';
import '../widget/function/w_slider_work_hour.dart';
import '../screen/s_servicedescription.dart';
// 임시
import '../screen/s_data_detail.dart'; // 옷 상세 조회 페이지 임포트

// 화면 이동 구현 아직 안함 - 정진영 (24.08.04)

class SettingContent extends StatefulWidget {
  const SettingContent({Key? key}) : super(key: key);

  @override
  State<SettingContent> createState() => _SettingContentState();
}

class _SettingContentState extends State<SettingContent> {

  // 유저 데이터 가져올 예정 - 정진영 (24.08.04)
  String _currentNickname = '먹쟁이 펭귄 S2';

  // 닉네임 변경 모달 팝업을 여는 메서드
  void _openNicknameChangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NicknameChangeDialog(
          currentNickname: _currentNickname,
          onNicknameChanged: (newNickname) {
            setState(() {
              // 닉네임 변경되면 할당됨
              _currentNickname = newNickname;
            });
          },
        );
      },
    );
  }

  // 출퇴근 시간 초기값 설정
  RangeValues _workHours = RangeValues(9, 18);
  // 출퇴근 시간 변경시 할당됨
  void _onWorkHoursChanged(RangeValues newWorkHours) {
    setState(() {
      _workHours = newWorkHours;
    });
    // 여기서 데이터 저장 로직을 추가할 수 있습니다.
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/background/bg.gif',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 뒤로 가기 아이콘 버튼
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              // Spacer는 왼쪽의 IconButton과 가운데 Text 사이의 간격을 벌림
              Spacer(flex: 2),
              // 중앙의 'Settings' 텍스트
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Spacer는 가운데 Text와 오른쪽 간격을 맞추기 위해 사용
              Spacer(flex: 3),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0), // Settings 텍스트와 OpaqueBox 사이의 간격 조정
            child: OpaqueBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  ListTile(
                    title: Text(_currentNickname, style: TextStyle(fontWeight: FontWeight.w500)),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, size: 20.0,),
                      color: Colors.grey,
                      onPressed: _openNicknameChangeDialog,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('출퇴근 시간 조정',style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: WorkHourSlider(
                      initialWorkHours: _workHours,
                      onWorkHoursChanged: _onWorkHoursChanged,
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  // 서비스 설명 페이지 이동
                  ListTile(
                    title: Text('서비스 설명', style: TextStyle(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DescriptionService()),
                      );
                    },
                  ),

                  // Divider(),
                  // ListTile(
                  //   title: Text('로그아웃', style: TextStyle(fontWeight: FontWeight.w500)),
                  //   onTap: () {},
                  // ),

                  Divider(),
                  ListTile(
                    title: Text('API 테스트', style: TextStyle(fontWeight: FontWeight.w500)), // API 테스트 페이지로 이동
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ApiTestPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
