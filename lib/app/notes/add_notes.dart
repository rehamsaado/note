import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant/link_api.dart';
import '../../global_widget/app_text_field.dart';
import '../../global_widget/crud.dart';
import '../../main.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  File? myFile;
  Crud crud = Crud();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  addNotes() async {
    if (myFile == null) {
      return ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("add your photo")));
    }
    if (formState.currentState!.validate()) {
      var response = await crud.postRequestWithFile(linkAddNotes, {
        'title': titleController.text,
        'content': contentController.text,
        'id': sharedPref.getString("id"),
      }, myFile!);

      if (response['status'] == "success") {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Notes")),
      body: Container(
        child: Form(
          key: formState,
          child: ListView(
            padding: EdgeInsets.all(19),
            children: [
              AppTextField(
                hint: "title",
                mycontroller: titleController,
                valid: (val) {
                  return validInput("$val!", 2, 20);
                },
              ),
              SizedBox(height: 10),
              AppTextField(
                hint: "content",
                mycontroller: contentController,
                valid: (val) {
                  return validInput("$val!", 2, 100);
                },
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (context) => Container(
                          width: double.infinity,
                          height: 100,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  XFile? xFile = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  Navigator.of(context).pop();
                                  myFile = File(xFile!.path);
                                  setState(() {

                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text("choose image from gallery"),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  XFile? xFile = await ImagePicker().pickImage(
                                    source: ImageSource.camera,
                                  );
                                  Navigator.of(context).pop();
                                  myFile = File(xFile!.path);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text("choose image from camera"),
                                ),
                              ),
                            ],
                          ),
                        ),
                  );
                },
                color: myFile == null ? Colors.blue : Colors.green,
                child: Text(
                  "choose your image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  addNotes();
                },
                color: Colors.blue,
                child: Text("add", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
