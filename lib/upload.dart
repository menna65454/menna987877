// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:login2/profilescreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

import 'alert.dart';
import 'camerascreen.dart';
import 'editprofile.dart';
import 'history.dart';


class Upload_Page extends StatefulWidget {
  Upload_Page({super.key});

  @override
  State<Upload_Page> createState() => _Upload_PageState();
}

class _Upload_PageState extends State<Upload_Page> {
  int _selectedIndex = 3; 
    String? avatarUrl;
     Map<String, dynamic>? userData;


 Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase.from('profiles').select().eq('id', user.id).single();
    setState(() {
      userData = response;
    });
  }

  String getFirstName(String fullName) {
    // تقسيم النص إلى كلمات واستخراج أول كلمة
    return fullName.split(' ')[0];
  }


   Future<void> _fetchUserAvatar() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await supabase.from('profiles').select('avatar_url').eq('id', user.id).single();

    setState(() {
      avatarUrl = response['avatar_url'];
    });
  }



  void _onItemTapped(int index) {
    // لا تفعل شيئًا إذا تم النقر على نفس الصفحة

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = Upload_Page();
        break;
      case 1:
        nextScreen = History();
        break;
      case 2:
        nextScreen = ProfileScreen();
        break;
      case 3:
        nextScreen = ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
   void initState() {
    super.initState();
    _fetchUserAvatar();
            _fetchUserData();

  }
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 7),
          child: CircleAvatar(
      radius: 50,
      backgroundImage: avatarUrl != null
          ? NetworkImage(avatarUrl!)
          : const AssetImage('assets/default_avatar.png') as ImageProvider, 
    )
        ),
        title:  userData == null
          ? const Center(child: CircularProgressIndicator())
          :
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              
              Text(
                    'Hi , ${getFirstName(userData!['full_name'] ?? '')}',
                style: TextStyle(
                  color: Color(0xFF0C0C0C),
                  fontSize: 20,
                  fontFamily: 'Inria Serif',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
             
            ],
          ),
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
                SizedBox(height: 70,),
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
            const SizedBox(height: 20),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // تعيين العنصر المحدد
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // استدعاء التنقل عند الضغط
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
