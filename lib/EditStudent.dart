import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'studentModel.dart';


class EditStudent extends StatefulWidget
{
  final String documentID;

  const EditStudent({Key? key, required this.documentID}) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    var student = Provider.of<StudentModel>(context, listen:false).get(widget.documentID);
      nameController.text = student!.name;
      idController.text = student.id;

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Student"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.ios_share),
              tooltip: 'Copy Profile Details',
              onPressed: () {
                var iter = 0;
                var scoresString = "";
                while(iter < student.scores.length){
                  scoresString += "Week ${iter + 1}: Score ${student.scores[iter]}\n";
                  iter += 1;
                }
                String text = 'Name: ${student.name}, ID: ${student.id},'
                    ' Profile Picture: ${student.profilePictureUrl},'
                    '\n$scoresString';

                Clipboard.setData(new ClipboardData(text: text));
                showMessage("Copied!",Colors.green,context);
              },
            ), //IconButton
          ],
        ),
        resizeToAvoidBottomInset : false,
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
                          Row(
                            children: <Widget>[
                              Container(
                                height: 150,
                                width: 150,
                                child: Image.network(student.profilePictureUrl),
                              ),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Column(
                                   children: <Widget>[
                                     TextFormField(
                                       controller: idController,
                                       validator: (value){
                                         if(value!.isEmpty) return "required!";
                                       },
                                     ),
                                     TextFormField(
                                       controller: nameController,
                                       validator: (value){
                                         if(value!.isEmpty) return "required!";
                                       },
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  student.name = nameController.text;
                                  student.id = idController.text;

                                  Provider.of<StudentModel>(context, listen:false).update(widget.documentID, student);
                                  showMessage("Profile Updated!",Colors.green, context);
                                }
                              },
                              child: Text("Update Profile"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemBuilder: (_, index) {
                          var score = student.scores[index];
                          var weeksScoreString = 'Week ${index + 1} \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t Score $score';
                          return ListTile(
                            title: Text(weeksScoreString)
                          );
                        },
                        itemCount: student.scores.length
                    ),
                  )
                ]
            )
        )
    );
  }
}
void showMessage(String message, Color messageColour, BuildContext context){
  var snackBar = SnackBar(content: Text(message),backgroundColor: messageColour);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}