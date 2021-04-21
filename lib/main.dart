import 'dart:io';
import 'package:covid_1984/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() => runApp(Covid());

class Covid extends StatelessWidget {
  // This widget is the root of your application.s
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NHS COVID-19',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  String stripped;
  int opened = 0;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            //aspectRatio: MediaQuery.of(context).size.height / 2,
            child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            margin: EdgeInsets.only(top: 0),
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          cameraOverlay(padding: 25, aspectRatio: 1, color: Color(0x55000000)),
          textOverlay()
        ])),
      ),
    );
  }

  Widget textOverlay() {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(left: 22, right: 22, bottom: 110),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Scan an official NHS QR code to check in',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25.0)),
            SizedBox(
              height: 20,
            ),
            Text('How it helps us stay safe',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
            SizedBox(
              height: 20,
            ),
            Text(
                'checking in makes sure that  people are alerted of potential exposure to coronavirus at a venue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
            SizedBox(
              height: 20,
            ),
            if (stripped != null)
              Text(stripped,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 17.0))
            else
              Text('',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 17.0)),
          ],
        ));
  }

  Widget cameraOverlay({double padding, double aspectRatio, Color color}) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        horizontalPadding = padding;
        verticalPadding = (constraints.maxHeight -
                ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
            2;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      return Stack(fit: StackFit.expand, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(width: horizontalPadding, color: Colors.black)),
        Align(
            alignment: Alignment.centerRight,
            child: Container(width: horizontalPadding, color: Colors.black)),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: 90,
                color: Colors.black)),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: MediaQuery.of(context).size.height / 2,
                color: Colors.black)),
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 22),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
        ),
      ]);
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      String s = scanData.code;
      s.replaceAll(new RegExp('UKC19TRACING:1:'), '');
      try {
        stripped = '';
        Map<String, dynamic> payload = Jwt.parseJwt(s);
        print(payload['opn']);
        setState(() {
          print(scanData.code);
          stripped = payload['opn'];
          result = scanData;
          opened++;
        });
        if (opened == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Success(recordObject: stripped)),
          );
        }
      } on Exception catch (e) {
        print('QR CODE ERROR');
        setState(() {
          stripped = scanData.code + 'Error read';
        });
      } catch (error) {
        print('QR CODE ERROR');
        setState(() {
          stripped = scanData.code + 'Error read';
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
