// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_final_fields, unused_field
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

final supabase = Supabase.instance.client;

class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  bool _obscureText = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (res.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged in!')),
        );
        // Navigate to home screen
      }
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      await supabase.auth.resetPasswordForEmail(
        _emailController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send reset email')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: 812,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFF0A4627),
                    Color(0xFF24744B),
                    Color(0xFF3CAB72),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 180),
              Center(
                child: Text(
                  'Forger Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w700,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Color(0xFF0A4627),
                          Color(0xFF24744B),
                        ], // Gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTRB(
                          0, 0, 200, 70)), // Adjust the Rect size accordingly
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                  child: Text(
                'Mail Address here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0C0C0C),
                  fontSize: 20,
                  fontFamily: 'Inria Serif',
                  fontWeight: FontWeight.w400,
                ),
              )),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Enter the email address associated with your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF797979),
                    fontSize: 16,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Email',
                style: TextStyle(
                  color: Color(0xFF0C0C0C),
                  fontSize: 18,
                  fontFamily: 'Inria Serif',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.black, // لون الحدود
                        width: 2,
                      )),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: double.infinity, // الارتفاع المطلوب
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Colors.transparent), // اجعل الخلفية شفافة
                    side: WidgetStatePropertyAll(
                      BorderSide(
                          color: Colors.white, width: 2), // تحديد لون الحدود
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // تعديل شكل الحواف
                      ),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF3CAB72), // اللون الأول
                          Color(0xFF24744B), // اللون الثاني
                          Color(0xFF0A4627), // اللون الثالث
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                          24), // نفس الحواف المستخدمة في `OutlinedButton`
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      child: Text(
                        "Recover Password",
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
              )
            ]),
          )),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.05, // تحديد الموقع يسار
            top: MediaQuery.of(context).size.height * 0.08, // تحديد الموقع أعلى
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    )));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
