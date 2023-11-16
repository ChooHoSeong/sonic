import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String userName;
  final int CC;
  final DateTime timestamp;

  MyDrawer(this.userName, this.CC, this.timestamp, {Key? key}) : super(key: key);

  // Function to compute the time difference
  Map<String, int> computeTimeDifference(DateTime timestamp) {
    final currentDateTime = DateTime.now();
    final difference = currentDateTime.difference(timestamp);

    return {
      'days': difference.inDays,
      'hours': difference.inHours,
      'minutes': difference.inMinutes
    };
  }

  @override
  Widget build(BuildContext context) {
    final timeDifference = computeTimeDifference(timestamp);

    return ListTile(
      title: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 8),
        width: 100,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$userName'),
            Row(
              children: [
                Text(
                  '${timeDifference['days']}일 ${timeDifference['hours']}시간 ${timeDifference['minutes']}분 전',
                  style: TextStyle(color: Colors.grey),
                ),
                CircleAvatar(
                  backgroundColor: HSVColor.fromAHSV(1.0, CC.toDouble(), 1.0, 1.0).toColor(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}