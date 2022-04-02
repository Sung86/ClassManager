import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ClassList.dart';
import 'WeekClass.dart';
import 'studentModel.dart';

class ClassManagement extends StatefulWidget
{
  ClassManagement({Key? key}) : super(key: key);

  @override
  _ClassManagementState createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement>
{
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(
        builder:buildScaffold
    );
  }

  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {
    const totalWeek = 13;

    return Scaffold(
      appBar: AppBar(
        title: Text("Class Management"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        splashColor: Colors.grey,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ClassList()
          ));
        },
        child: Icon(Icons.people),
      ),
      body: Center(
          child: Container(
            width: 200,
            height: 500,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: weekButtonsWidget(totalWeek, context),
            ),
          )
      ),
    );
  }
}

List<Widget> weekButtonsWidget(numberOfButtons, context){
  List<Widget> weekButtons = [];
  int iter = 1;
  while(iter <= numberOfButtons){
    var weekClassObj = WeekClass(weekNumber: iter.toString());

    Widget widget = Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => weekClassObj)
          );
        },
        child: Text(
            'Week $iter',
            style: TextStyle(fontSize: 19)
        ),
      ),
    );
    weekButtons.add(widget);
    iter += 1;
  }
  return weekButtons;
}