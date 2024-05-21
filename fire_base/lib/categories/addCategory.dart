import 'package:fire_base/widgets/customButton.dart';
import 'package:fire_base/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;

  Future<void> addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.add(
            {'id': FirebaseAuth.instance.currentUser!.uid, 'name': name.text});
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e.toString());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Form(
        key: formState,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: h * .025, horizontal: w * .025),
                  child: CustomTextFormField(
                      content: 'Enter Name',
                      h: h,
                      w: w,
                      txController: name,
                      validator: (val) {
                        if (val == '') {
                          return "can't be empty";
                        }
                      }),
                ),
                CustomButton(
                  text: 'Add',
                  onPressed: () {
                    addCategory();
                  },
                  h: h,
                  w: w,
                  color: Colors.orange,
                  txColor: Colors.white,
                ),
              ]),
      ),
    );
  }
}
