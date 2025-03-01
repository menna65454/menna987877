import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🔹 خلفية بيضاء بالكامل
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0, // 🔹 إزالة الظل من الـ AppBar
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      body: ListView(
        children: [
          _buildSettingItem(
            context,
            icon: Icons.lock,
            title: 'Password Manager',
            page: PasswordManagerPage(),
          ),
          _buildSettingItem(
            context,
            icon: Icons.phone,
            title: 'Phone Manager',
            page: PhoneManagerPage(),
          ),
          _buildSettingItem(
            context,
            icon: Icons.delete,
            title: 'Delete Account',
            page: DeleteAccountPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon, required String title, required Widget page}) {
    return Card(
      elevation: 0, // 🔹 إزالة الظل
      color: Colors.white, // 🔹 لون الخلفية أبيض
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
      ),
    );
  }
}

// صفحات فارغة لتجنب الأخطاء
class PasswordManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🔹 جعل الصفحة بيضاء
      appBar: AppBar(
        title: Text('Password Manager', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
    );
  }
}

class PhoneManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Phone Manager', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
    );
  }
}

class DeleteAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Delete Account', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
    );
  }
}
