// ignore_for_file: unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_base/widgets/customTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

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
    userName.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
                    'Sign Up',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: h * .01),
                  Text(
                    'Sign Up to continue using the application',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: h * .04),
                  Text(
                    'User Name',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: h * .01),
                  CustomTextFormField(
                      content: 'Enter Your User name',
                      validator: (val) {
                        if (val == "") {
                          return "can't be empty";
                        }
                      },
                      txController: userName,
                      h: h,
                      w: w),
                  SizedBox(height: h * .03),
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
                ],
              ),
            ),
            SizedBox(height: h * .03),
            MaterialButton(
              height: h * .05,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * .5)),
              child: Text('Sign Up'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );

                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.pushReplacementNamed(context, 'logIn');
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The password provided is too weak..',
                      )..show();
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The account already exists for that email.',
                      )..show();
                    }
                  } catch (e) {
                    print(e);
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
                "Have an account ? ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                child: Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'logIn');
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
