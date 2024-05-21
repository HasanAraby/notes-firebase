import 'package:fire_base/home.dart';
import 'package:fire_base/widgets/customButton.dart';
import 'package:fire_base/widgets/customTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // if you didn't continue to sign in it will be null and an error will happen
    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed('home');
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(w * .05),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: h * .1,
                            ),
                            width: w * .2,
                            height: h * .1,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(70),
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: w * .2,
                              height: h * .2,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: h * .05),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: h * .01),
                        Text(
                          'login to continue using the application',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: h * .04),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: h * .01),
                        CustomTextFormField(
                            content: 'Enter Your Email',
                            validator: (val) {
                              if (val == "") {
                                return "can't be empty";
                              }
                            },
                            txController: email,
                            h: h,
                            w: w),
                        SizedBox(height: h * .03),
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: h * .01),
                        CustomTextFormField(
                          content: 'Enter Your Password',
                          validator: (val) {
                            if (val == "") {
                              return "can't be empty";
                            }
                          },
                          txController: password,
                          h: h,
                          w: w,
                        ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: h * .008, bottom: h * .0012),
                            alignment: Alignment.topRight,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (email.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Attention',
                                desc: 'Type your email First',
                              )..show();
                              return;
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Attention',
                                desc: 'Check your email to reset your password',
                              )..show();
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Attention',
                                  desc: 'Not valid email',
                                )..show();
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: h * .01),
                  MaterialButton(
                    height: h * .05,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * .5)),
                    child: Text('Login'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        try {
                          isLoading = true;
                          setState(() {});
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          isLoading = false;
                          setState(() {});
                          if (credential.user!.emailVerified) {
                            Navigator.of(context).pushReplacementNamed('home');
                          } else {
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'check your mail to activate your account',
                            )..show();
                          }
                        } on FirebaseAuthException catch (e) {
                          isLoading = false;
                          setState(() {});
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'No user found for that email.',
                            )..show();
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Wrong password provided for that user.',
                            )..show();
                          }
                        }
                      } else {
                        print('not valid');
                      }
                    },
                  ),
                  SizedBox(height: h * .01),
                  Text(
                    'OR',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: h * .01),
                  MaterialButton(
                    height: h * .05,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * .5)),
                    child: Text('Login With Google'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () async {
                      await signInWithGoogle();
                    },
                  ),
                  SizedBox(height: h * .02),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Don't have an account ? ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'signUp');
                      },
                    ),
                  ]),
                ],
              ),
            ),
    );
  }
}
