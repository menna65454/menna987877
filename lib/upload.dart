// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

import 'alert.dart';
import 'camerascreen.dart';

class Upload_Page extends StatefulWidget {
  Upload_Page({super.key});

  @override
  State<Upload_Page> createState() => _Upload_PageState();
}

class _Upload_PageState extends State<Upload_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: CircleAvatar(
            radius: 25,
          ),
        ),
        title: Column(
          children: [
            Text(
              'Hi, Laila',
              style: TextStyle(
                color: Color(0xFF0C0C0C),
                fontSize: 14,
                fontFamily: 'Inria Serif',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            Text(
              'dolores ratione officiis',
              style: TextStyle(
                color: Color(0xFF797979),
                fontSize: 12,
                fontFamily: 'Inria Sans',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
        actions: [
          Icon(
            Icons.menu,
            size: 23,
            color: Colors.teal,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Lip Reading',
                  style: TextStyle(
                    color: Color(0xFF0A4627),
                    fontSize: 32,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                    letterSpacing: -0.61,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "assets/upload.jpeg",
                    width: 400,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("How would you like to upload your video?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoPickerPage()),
                              );
                            },
                            child: Text("From Gallery",
                                style: TextStyle(color: Colors.blue)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CameraScreen()),
                              );
                              // فتح الكاميرا (يمكنك إضافة منطق هنا إذا رغبت)
                            },
                            child: Text("Open Camera",
                                style: TextStyle(color: Colors.blue)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Exit",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Upload',
                  style: TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 15,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              width: 320,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.00, -0.00),
                  end: Alignment(1, 0),
                  colors: [Color(0xFF3CAB72), Color(0xFF0A4627)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 2,
                    offset: Offset(2, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
