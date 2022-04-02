import 'package:class_manager/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'studentModel.dart';

class WeekClass extends StatefulWidget
{
  final weekNumber;
  WeekClass({Key? key, required this.weekNumber}) : super(key: key);

  @override
  _WeekClassState createState() => _WeekClassState();

}

class _WeekClassState extends State<WeekClass>
{
  late int weekNumber;

  void goToNextWeek(){
    setState(() =>
      weekNumber += 1
    );
  }
  void goToPrevWeek(){
    setState(() =>
    weekNumber -= 1
    );
  }
  @override
  void initState() {
    super.initState();
    weekNumber = int.parse(widget.weekNumber);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(
        builder:buildScaffold
    );
  }
  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Class List/ Week $weekNumber"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "prevWeek",
              backgroundColor: Colors.deepPurple,
              splashColor: Colors.grey,
              onPressed: () {
                if(weekNumber > 1) goToPrevWeek();
              },
              child: Icon(Icons.navigate_before),
            ),
            FloatingActionButton(
              heroTag: "nextWeek",
              backgroundColor: Colors.deepPurple,
              splashColor: Colors.grey,
              onPressed: () {
                if(weekNumber < 12) goToNextWeek();
              },
              child: Icon(Icons.navigate_next),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(!studentModel.loading)
              Container(
                width: double.infinity,
                height: 40,
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Average Score for Week $weekNumber: ${calculateClassAverage(studentModel.classList)}%",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54
                    ),
                  ),
                ),
              ),
            if(studentModel.loading) CircularProgressIndicator() else Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,8,0,10),
                child: ListView.builder(
                    itemBuilder: (_, index) {
                      var student = studentModel.classList[index];
                      var score = student.scores[weekNumber - 1];
                      var grade = convertScoreToGrade(int.parse(score));
                      final List<String> grades = <String>["HD+", "HD", "DN", "CR","PP","NN"];
                      int selectedGrade = grades.indexOf(grade);

                      return ListTile(
                        title: Text(student.name),
                        subtitle: Text(student.id),
                        trailing: Wrap(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text("Week $weekNumber: ${student.scores[weekNumber - 1]}%",
                              style: TextStyle(color: Colors.grey)),
                            ),
                            Container(
                              child:DropdownButton(
                                value: selectedGrade,
                                items: grades.map((String grade) {
                                  return DropdownMenuItem<int>(
                                    child: Text(grade),
                                    value: grades.indexOf(grade)
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedGrade = value as int;
                                    student.scores[weekNumber-1] = convertGradeToScore(grades[selectedGrade]);
                                    StudentModel().update(student.documentID!, student);
                                  });
                                },
                              ),
                            )
                          ],
                        ),
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
  var scoreGrade = <int, String>{100: 'HD+', 80: 'HD', 70: 'DN', 60:'CR', 50:'PP', 0:'NN'};

  String convertScoreToGrade(int score) {
    return scoreGrade.entries.firstWhere((element) => element.key == score).value;
  }
  String convertGradeToScore(String grade) {
    return scoreGrade.entries.firstWhere((element) => element.value == grade).key.toString();
  }

  String calculateClassAverage(List<Student> classlist) {
    int totalScore = 0;
    for(int iter = 0; iter < classlist.length; iter++){
      totalScore += int.parse(classlist[iter].scores[weekNumber-1]);
    }
    var averageScore =  totalScore/classlist.length;
    return averageScore.toStringAsFixed(0);
  }
}
