// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final supabase = Supabase.instance.client;

class Personalinfo extends StatefulWidget {
  const Personalinfo({super.key});

  @override
  State<Personalinfo> createState() => _PersonalinfoState();
}

class _PersonalinfoState extends State<Personalinfo> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await supabase.from('profiles').select().eq('id', user.id).single();
    setState(() => userData = response);
  }

  Future<void> _updateProfile(
      String fullName, String phoneNumber, String? avatarUrl) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('profiles').update({
      'full_name': fullName,
      'phone_number': phoneNumber,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', user.id);

    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // أضف هذا السطر لجعل الخلفية بيضاء
      appBar: AppBar(
        backgroundColor: Colors.white, // أضف هذا السطر لجعل الخلفية بيضاء

        title: const Text(
          'Personal Info',
          style: TextStyle(
            color: Color(0xFF0A4627),
            fontSize: 28,
            fontFamily: 'Inria Serif',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedImageUrl = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    userData: userData,
                    onUpdate: _updateProfile,
                  ),
                ),
              );

              if (updatedImageUrl != null) {
                setState(() {
                  userData!['avatar_url'] = updatedImageUrl;
                });
              }
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Inria Sans',
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (userData!['avatar_url'] != null &&
                                userData!['avatar_url'].isNotEmpty)
                            ? NetworkImage(
                                '${userData!['avatar_url']}?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                            : null,
                        child: (userData!['avatar_url'] == null ||
                                userData!['avatar_url'].isEmpty)
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        userData!['full_name'] ?? 'No Name',
                        style: const TextStyle(
                          color: Color(0xFF0C0C0C),
                          fontSize: 16,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.grey.shade200, // ✅ تغيير لون البطاقة

                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text(
                        'Full Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      subtitle: Text(
                        userData!['full_name'] ?? 'No Name',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 152, 150, 150),
                          fontSize: 16,
                          fontFamily: 'Inria Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: Colors.grey.shade200, // ✅ تغيير لون البطاقة

                    child: ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text(
                        'Email Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      subtitle: Text(
                        userData!['email'],
                        style: const TextStyle(
                          color: Color(0xFF797979),
                          fontSize: 16,
                          fontFamily: 'Inria Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: Colors.grey.shade200, // ✅ تغيير لون البطاقة

                    child: ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: const Text(
                        'Phone Number',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      subtitle: Text(
                        userData!['phone_number'] ?? 'Not provided',
                        style: const TextStyle(
                          color: Color(0xFF797979),
                          fontSize: 16,
                          fontFamily: 'Inria Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final Function(String, String, String?) onUpdate;

  const EditProfileScreen(
      {super.key, required this.userData, required this.onUpdate});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  String? _imageUrl; // لتخزين رابط الصورة الحالية

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      _fullNameController.text = widget.userData!['full_name'] ?? '';
      _phoneController.text = widget.userData!['phone_number'] ?? '';
      _imageUrl = widget.userData!['avatar_url']; // تحميل الصورة الحالية
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final fileExt = imageFile.path.split('.').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${user.id}_$timestamp.$fileExt';
    final filePath = 'avatars/$fileName';

    try {
      // ✅ حذف الصورة القديمة (اختياري)
      final files =
          await supabase.storage.from('avatars').list(path: 'avatars/');
      for (var file in files) {
        if (file.name.startsWith(user.id)) {
          await supabase.storage
              .from('avatars')
              .remove(['avatars/${file.name}']);
          break;
        }
      }

      // ✅ رفع الصورة الجديدة باسم فريد
      final imageBytes = await imageFile.readAsBytes();
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            imageBytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      // ✅ الحصول على الرابط العام
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ جعل الخلفية بيضاء
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF0A4627),
            fontSize: 28,
            fontFamily: 'Inria Serif',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
        backgroundColor: Colors.white, // ✅ جعل شريط التطبيق أبيض أيضًا
        elevation: 0, // ✅ إزالة الظل لجعل التصميم أنظف
        iconTheme:
            const IconThemeData(color: Colors.black), // تغيير لون أيقونة الرجوع
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
           // ✅ التأكد من أن كل الخلفية بيضاء
          child: Padding(
                    padding: const EdgeInsets.all(20.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // محاذاة جميع العناصر لليسار
            
              children: [
                // ✅ الصورة الشخصية مع زر اختيار صورة جديدة
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      
                         CircleAvatar(
                          radius: 50,
                          backgroundImage: _image != null
                              ? FileImage(_image!) // صورة جديدة من الجهاز
                              : (_imageUrl != null
                                  ? NetworkImage(
                                      '$_imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                                  : null),
                          child: (_image == null &&
                                  (_imageUrl == null || _imageUrl!.isEmpty))
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
                        ),
                      
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF0A4627),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
            
                // ✅ حقل الاسم
                Text(
                  'Full Name',
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left, // إضافة هذه السطر لمحاذاة النص لليسار
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email',
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                    textAlign: TextAlign.left, // محاذاة النص لليسار
        
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // ✅ حقل رقم الهاتف
                Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                    textAlign: TextAlign.left, // محاذاة النص لليسار
        
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
            
                // ✅ زر الحفظ مع تدرج الألوان
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3CAB72),
                          Color(0xFF24744B),
                          Color(0xFF0A4627),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        String? imageUrl = _imageUrl;
                        if (_image != null) {
                          imageUrl = await _uploadImage(_image!);
                        }
            
                        await widget.onUpdate(
                          _fullNameController.text,
                          _phoneController.text,
                          imageUrl,
                        );
            
                        setState(() {
                          _imageUrl = imageUrl;
                        });
            
                        if (mounted) {
                          Navigator.pop(context, imageUrl);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  get error => null;
}
