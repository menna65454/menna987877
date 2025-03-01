import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'editprofile.dart';
import 'history.dart';
import 'logout.dart';
import 'notification.dart';
import 'setting.dart';
import 'upload.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  int _selectedIndex = 2;
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


  Future<void> _fetchUserAvatar() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await supabase.from('profiles').select('avatar_url').eq('id', user.id).single();

    setState(() {
      avatarUrl = response['avatar_url'];
    });
  }

  void _onItemTapped(int index, BuildContext context) {
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
  
 

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white, // 🔹 جعل الخلفية بيضاء بالكامل
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          :
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 70),
            const Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black, // 🔹 تغيير اللون إلى الأسود
                  fontSize: 24,
                  fontFamily: 'Inria Serif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
                       userData!['full_name'] ?? 'No Name',
            style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontFamily: 'Inria Sans',
        fontWeight: FontWeight.w400,
        height: 1.50,
    ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.person,
                    text: "Personal Info",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Personalinfo()),
                    ),
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.notifications,
                    text: "Notification",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Notification1()),
                    ),
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.history,
                    text: "History",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => History()),
                    ),
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.settings,
                    text: "Setting",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    ),
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.logout,
                    text: "Log Out",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Logout()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // 🔹 تغيير اللون ليكون واضحًا
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black), // 🔹 أيقونات سوداء
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black), // 🔹 لون النص أسود
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black), // 🔹 أيقونة السهم باللون الأسود
      onTap: onTap,
    );
  }
}
