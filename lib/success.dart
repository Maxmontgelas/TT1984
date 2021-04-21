import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Success extends StatefulWidget {
  final String recordObject;

  // In the constructor, require a RecordObject.
  Success({Key key, @required this.recordObject}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<Success> {
  String now = DateFormat('d MMM y HH:mm').format(DateTime.now()); // 28/03/2020
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(left: 22, right: 22, bottom: 20),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image(
                  image: AssetImage('assets/images/check.png'),
                  height: 120,
                ),
                SizedBox(
                  height: 110,
                ),
                Text('Thank you for checking in to ' + widget.recordObject,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 40,
                ),
                Text(now,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 40,
                ),
                Text(
                    'The app is the fastest way to be alerted of potential exposure to coronovirus at a venue',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14.0)),
                SizedBox(
                  height: 40,
                ),
                Text('Wrong check-in? Tap to cancel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 40,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 300, height: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to first route when tapped.
                      SystemNavigator.pop();
                    },
                    child: Text('Back to home',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )));
  }
}
