import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AddStudent.dart';
import 'EditStudent.dart';
import 'studentModel.dart';

class ClassList extends StatefulWidget
{
  ClassList({Key? key}) : super(key: key);

  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList>
{
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(
        builder:buildScaffold
    );
  }

  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class List"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        splashColor: Colors.grey,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddStudent()
          ));
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(studentModel.loading) CircularProgressIndicator() else Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,10),
                child: ListView.builder(
                    itemBuilder: (_, index) {
                      var student = studentModel.classList[index];
                      return ListTile(
                        leading: Container(
                          child: Image.network(
                              student.profilePictureUrl,
                              fit: BoxFit.fill
                          ),
                          height: 100,
                          width: 100,
                        ),
                        title: Text(student.name),
                        subtitle: Text(student.id),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Provider.of<StudentModel>(context, listen:false).delete(student.documentID!);
                          },
                          child: Text("Delete"),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => EditStudent(
                                documentID: student.documentID!,
                              )
                          ));
                        },
                      );
                    },
                    itemCount: studentModel.classList.length
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
