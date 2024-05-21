import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_base/note/addNote.dart';
import 'package:fire_base/note/editNote.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewNote extends StatefulWidget {
  final String categoryId;
  const ViewNote({super.key, required this.categoryId});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes')
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
        title: Text('Note'),
      ),
      body: WillPopScope(
        child: isLoading
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
                          builder: (context) => EditNote(
                              noteId: data[index].id,
                              categoryId: widget.categoryId,
                              value: data[index]['note'])));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.rightSlide,
                          title: 'Delete',
                          desc: 'Do You Want To Delete This Note',
                          btnCancelText: 'No',
                          btnOkText: 'Yes',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection('categories')
                                .doc(widget.categoryId)
                                .collection('notes')
                                .doc(data[index].id)
                                .delete();

                            if (data[index]['url'] != 'none') {
                              FirebaseStorage.instance
                                  .refFromURL(data[index]['url'])
                                  .delete();
                            }

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ViewNote(categoryId: widget.categoryId)));
                          })
                        ..show();
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(w * .008),
                        child: Column(children: [
                          Expanded(child: Text(data[index]['note'])),
                          if (data[index]['url'] != 'none')
                            Expanded(child: Image.network(data[index]['url'])),
                        ]),
                      ),
                    ),
                  );
                },
              ),
        onWillPop: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('home', (route) => false);
          return Future.value(false);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(categoryId: widget.categoryId)));
        },
      ),
    );
  }
}
