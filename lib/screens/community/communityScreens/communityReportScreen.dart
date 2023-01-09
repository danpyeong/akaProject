import 'package:flutter/material.dart';
import 'package:aka_project/screens/community/services/toast.dart';

class CommuReportScreen extends StatelessWidget {
  const CommuReportScreen({super.key});
  void saveReport() {}

  @override
  Widget build(BuildContext context) {
    Color bc = Color.fromARGB(255, 255, 173, 84);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bc,
          title: const Text("신고 게시판"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
                size: 15,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: ReportWidget());
  }
}

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  List<String> dropdownList = [
    '없음',
    '음란물',
    '도배',
    '욕설/비하',
    '정치적 발언',
    '광고',
    '사기'
  ];
  String selectedDropdown = '없음';

  final contentController = TextEditingController();

  // 내용 작성
  Widget _ContentWrite() {
    final int maxLines = 20;
    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: TextField(
            style: TextStyle(fontSize: 16),
            controller: contentController,
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: '내용을 입력하세요',
              hintStyle: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ReportList() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        value: selectedDropdown,
        items: dropdownList.map((String item) {
          return DropdownMenuItem<String>(
            child: Text('$item'),
            value: item,
          );
        }).toList(),
        onChanged: (dynamic value) {
          setState(() {
            selectedDropdown = value;
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 42,
        underline: SizedBox(),
        isExpanded: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReportList(),
        Padding(padding: EdgeInsets.all(10)),
        _ContentWrite(),
      ],
    );
  }
}
