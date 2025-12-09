import 'package:fish_farm_app/screens/login_screen.dart';
import 'package:fish_farm_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _formFade;
  late final Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _logoFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));
    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _formFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    ));
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---------- INPUT FIELD WIDGET ----------
  Widget inputField(String hint, {bool isPassword = false}) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                // ---------------- TOP GREY AREA ----------------
                Container(
                   // was 230

                ),
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: const Image(
                      image: AssetImage("assets/images/logo.png"),

                      height: 150,
                      width: 150,
                    ),

                  ),

                ),
                SizedBox(height: 10,),
                Text("Khyber Pakhtunkhwa\n"
                "Fisheries Department ",style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,color: Color(0xFF1F5E3C)
                ),),
                // ---------------- CURVED GREEN AREA ----------------
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70, // keep 75% height
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: CurvePainter(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.95,
                          width: double.infinity,
                          color: const Color(0xFF1F5E3C),
                        ),
                      ),
                      // ---------------- FORM CONTENT ----------------
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: FadeTransition(
                            opacity: _formFade,
                            child: SlideTransition(
                              position: _formSlide,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 300,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person,color: Color(0xFF1F5E3C),),
                                        hintText: 'Full Name',
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 50,
                                    width: 300,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.email_outlined,color: Color(0xFF1F5E3C),),
                                        hintText: 'Email',
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 50,
                                    width: 300,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.password,color: Color(0xFF1F5E3C),),
                                        hintText: 'Password',
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 50,
                                    width: 300,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.password,color: Color(0xFF1F5E3C),),
                                        hintText: 'Confirm Password',
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  // LOGIN BUTTON (adds subtle tap-scale)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                        return const LoginScreen();
                                      }));
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don’t have an account? ",
                                        style: TextStyle(color: Colors.white70, fontSize: 14),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                            return const LoginScreen();
                                          }));
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

// ---------- CURVED SHAPE ----------
class CurvePainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 100, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
