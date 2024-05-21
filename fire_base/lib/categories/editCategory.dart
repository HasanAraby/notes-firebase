import 'package:fire_base/widgets/customButton.dart';
import 'package:fire_base/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key, required this.docId, required this.oldName});
  final String docId;
  final String oldName;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;

  Future<void> editCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.docId).update({
          'name': name.text,
        });
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    name.text = widget.oldName;
    super.initState();
  }

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
                  text: 'Save',
                  onPressed: () {
                    editCategory();
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
