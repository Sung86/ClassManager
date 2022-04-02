import 'dart:io';

import 'package:class_manager/student.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'studentModel.dart';


class AddStudent extends StatefulWidget
{

  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  late File selectedPicture;
  var uploadedPicture = false;
  final initialImg = "http://cdn1.sbnation.com/imported_assets/165776/photo-not-available_medium.jpg";
  var adding = false;

  void setAdding(val) {
    setState(() {
      adding = val;
    });
  }

  Future selectProfilePicture() async {
    final selected = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      selectedPicture = File(selected!.path);
      uploadedPicture = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(
        builder: buildScaffold
    );
  }

  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {
    {
      return Scaffold(
          appBar: AppBar(
            title: Text("Edit Student"),
          ),
          resizeToAvoidBottomInset: false,
          body: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: !uploadedPicture
                                      ? Image.network(
                                      initialImg, fit: BoxFit.fill)
                                      : Image.file(
                                      selectedPicture, fit: BoxFit.fill),
                                ),
                                ElevatedButton(
                                    child: Text("Upload Picture"),
                                    onPressed: () {
                                      selectProfilePicture();
                                    })
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "Name",
                                        ),
                                        controller: nameController,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "required!";
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "ID",
                                        ),
                                        controller: idController,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "required!";
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(

                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setAdding(true);
                            var profilePictureUrl = "";
                            var student = Student(id: idController.text,
                                name: nameController.text,
                                profilePictureUrl: "");
                            if (uploadedPicture) {
                              try {
                                var refName = '${idController.text}-${DateTime
                                    .now()
                                    .millisecondsSinceEpoch
                                    .toString()}';
                                var imageDir = FirebaseStorage.instance
                                    .ref('$refName.jpeg');

                                await imageDir.putFile(selectedPicture);
                                profilePictureUrl =
                                await imageDir.getDownloadURL();
                              } on FirebaseException catch (err) {
                                print('error: $err');
                              }
                              student.profilePictureUrl = profilePictureUrl;
                            } else {
                              student.profilePictureUrl = this.initialImg;
                            }
                            Provider.of<StudentModel>(context, listen:false).add(student);
                            Navigator.pop(context);
                            showMessage(
                                "Added New Student!", Colors.green, context);
                          }
                        },
                        child: Text("Add"),
                      ),
                    ),
                    if(adding) Text(
                        "adding . . .", style: TextStyle(color: Colors.orange)),
                  ]
              )
          )
      );
    }
  }
}
void showMessage(String message, Color messageColour, BuildContext context){
  var snackBar = SnackBar(content: Text(message),backgroundColor: messageColour);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}