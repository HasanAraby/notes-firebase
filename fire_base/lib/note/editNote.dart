import 'package:fire_base/note/viewNote.dart';
import 'package:fire_base/widgets/customButton.dart';
import 'package:fire_base/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNote extends StatefulWidget {
  final String noteId;
  final String categoryId;
  final String value;
  const EditNote(
      {super.key,
      required this.noteId,
      required this.categoryId,
      required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isLoading = false;
  Future<void> editNote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes');

    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await notes.doc(widget.noteId).update({'note': note.text});
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

  @override
  void initState() {
    super.initState();
    note.text = widget.value;
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
        title: Text('Edit Note'),
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
                  text: 'Save',
                  onPressed: () {
                    editNote();
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
