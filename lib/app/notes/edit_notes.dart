import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant/link_api.dart';
import '../../global_widget/app_text_field.dart';
import '../../global_widget/crud.dart';

class EditNote extends StatefulWidget {
  final notes;

  const EditNote({super.key, this.notes});

  @override
  State<EditNote> createState() => _AddNotesState();
}

class _AddNotesState extends State<EditNote> {
  File? myFile;

  Crud crud = Crud();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  editNote() async {
    if (formState.currentState!.validate()) {
      var response;
      if (myFile != null) {
        response = await crud.postRequestWithFile(linkEditNotes, {
          'title': titleController.text,
          'content': contentController.text,
          'id': widget.notes['notes_id'].toString(),
          'imagename': widget.notes['notes_image'].toString(),
        }, myFile!);
      } else {
        response = await crud.postRequest(linkEditNotes, {
          'title': titleController.text,
          'content': contentController.text,
          'id': widget.notes['notes_id'].toString(),
          'imagename': widget.notes['notes_image'].toString(),
        });
      }

      if (response['status'] == 'success') {
        Navigator.of(context).pushReplacementNamed("home");
      } else {}
    }
  }

  void initState() {
    titleController.text = widget.notes["notes_title"];
    contentController.text = widget.notes["notes_content"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Note")),
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
              AppTextField(
                hint: "content",
                mycontroller: contentController,
                valid: (val) {
                  return validInput("$val!", 2, 100);
                },
              ),
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
                                  setState(() {});
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
              MaterialButton(
                onPressed: () {
                  editNote();
                },
                color: Colors.blue,
                child: Text("Edit Note"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
