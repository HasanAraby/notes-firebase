import 'dart:io';
import 'package:fire_base/note/viewNote.dart';
import 'package:fire_base/widgets/customButton.dart';
import 'package:fire_base/widgets/customTextFormField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String categoryId;
  const AddNote({super.key, required this.categoryId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  File? file;
  String? url;

  bool isLoading = false;
  Future<void> addNote(context) async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes');

    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await notes.add({'note': note.text, 'url': url ?? 'none'});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNote(
                  categoryId: widget.categoryId,
                )));
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e.toString());
      }
    }
  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imgCamera = await picker.pickImage(source: ImageSource.camera);

    if (imgCamera != null) {
      file = File(imgCamera.path);
      var imgName = basename(imgCamera.path);

      var refeStorage = FirebaseStorage.instance.ref(imgName);
      await refeStorage.putFile(file!);
      url = await refeStorage.getDownloadURL();
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
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
                      content: 'Enter Your Note',
                      h: h,
                      w: w,
                      txController: note,
                      validator: (val) {
                        if (val == '') {
                          return "can't be empty";
                        }
                      }),
                ),
                CustomButton(
                  text: 'Add',
                  onPressed: () async {
                    await addNote(context);
                  },
                  h: h,
                  w: w,
                  color: Colors.orange,
                  txColor: Colors.white,
                ),
                SizedBox(
                  height: h * .009,
                ),
                CustomButton(
                  text: 'Upload Image',
                  onPressed: () async {
                    await getImage();
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
