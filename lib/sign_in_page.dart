import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:r_place_clone/home.dart';
import 'package:r_place_clone/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
      }
    }
  }

  // Future _googlesignin() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ["profile", "email"]).signIn();
  //   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  //   final OAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => HomePage()));
  // }

  //17 ocotber
  //trying google sign in by ash
  Future _googlesignin() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ["profile", "email"]).signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Error during Google Sign-In: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double fieldWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    child: Image.asset(
                      'assets/Logo.png',
                      height: screenHeight * 0.07,
                      width: screenHeight * 0.07,
                    )),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Welcome back',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Login to your account',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.02),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.02),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.02),
                                borderSide: BorderSide.none)),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  width: fieldWidth,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF36EDC4),
                        foregroundColor: Colors.white,
                        minimumSize: Size(fieldWidth, screenHeight * 0.05),
                        textStyle: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.02))),
                    child: Text('Login',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Sign in with",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    _googlesignin();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: screenWidth * 0.07,
                    child: Image.asset(
                      'assets/icons/Google.png',
                      height: screenWidth * 0.08,
                      width: screenWidth * 0.08,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: const Color(0xFF36EDC4),
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.04),
                Text("Powered by",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: screenHeight * 0.01),
                ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    child: Image.asset(
                      'assets/Logo_gdg.png',
                      height: screenHeight * 0.07,
                      width: screenHeight * 0.07,
                    )),
                Text("GDG IIIT Nagpur",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
