import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_base/categories/editCategory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base/note/viewNote.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () async {
                // to sign out if signed in with google
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('logIn', (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: h * .25),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewNote(categoryId: data[index].id)));
                  },
                  onLongPress: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Choose',
                        desc: 'Delete Or Edit',
                        btnCancelText: 'Delete',
                        btnOkText: 'Edit',
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(data[index].id)
                              .delete();
                          // setState(() {});
                          Navigator.of(context).pushReplacementNamed('home');
                        },
                        btnOkOnPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCategory(
                                    docId: data[index].id,
                                    oldName: data[index]['name'],
                                  )));

                          // print('=========================================');
                          // print(FirebaseAuth.instance.currentUser!.uid); //user id
                          // print(data[index]['id']);                      //user id
                          // print(data[index].id);                         // category id
                          // print(data[index]['name']);
                        })
                      ..show();
                  },
                  child: Card(
                    child: Container(
                      child: Column(children: [
                        Image.asset(
                          'assets/images/folder.png',
                          height: h * .2,
                        ),
                        Text(data[index]['name']),
                      ]),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushNamed('addCategory');
        },
      ),
    );
  }
}
