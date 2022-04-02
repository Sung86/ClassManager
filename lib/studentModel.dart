import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'student.dart';

class StudentModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Student> classList = [];
  CollectionReference studentsRef = FirebaseFirestore.instance.collection('students');
  bool loading = false;

  StudentModel(){
    fetch();
  }
  Student? get(String documentID)
  {
    if(documentID == "") return null;
    return classList.firstWhere((student) => student.documentID == documentID);
  }
  void fetch() async{
    classList.clear();
    loading = true;
    notifyListeners();
    var querySnapshot = await studentsRef.get();
    querySnapshot.docs.forEach((doc) {
      var student = Student.fromJson(doc.data() as Map<String, dynamic>);
      student.documentID = doc.id;
      classList.add(student);
    });
    classList.sort((a, b) => a.id.compareTo(b.id));
    await Future.delayed(Duration(seconds: 2));
    loading = false;
    notifyListeners();
  }
  void update(String documentID, Student student) async
  {
    loading = true;
    notifyListeners();
    await studentsRef.doc(documentID).set(student.toJson());
    fetch();
  }

  void add(Student student) async{
    classList.add(student);
    classList.sort((a, b) => a.id.compareTo(b.id));
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
    await studentsRef.add(student.toJson());
    fetch();
  }
  void delete(String documentID) async{
    classList.removeWhere((student) => student.documentID == documentID);
    classList.sort((a, b) => a.id.compareTo(b.id));
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
    await studentsRef.doc(documentID).delete();
    fetch();
  }

}