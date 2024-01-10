// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'Student.dart';
import 'errorhandler.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  List<QueryDocumentSnapshot> selectedStudents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showRegisteredStudents(context);
              },
              icon: Icon(Icons.people),
              label: Text("Show Registered Students"),
            ),
            
          ],
        ),
      ),
    );
  }

 Future<void> showRegisteredStudents(BuildContext context) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersRef = firestore.collection('users');
    QuerySnapshot querySnapshot = await usersRef.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registered Students'),
          content: FutureBuilder<List<Widget>>(
            future: fetchStudentWidgets(documents, firestore),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!,
                );
              } else {
                return Text('No data available.');
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Error retrieving registered students: $e');
  }
}
  Future<List<Widget>> fetchStudentWidgets(
  List<QueryDocumentSnapshot> documents, FirebaseFirestore firestore) async {
  List<Widget> studentWidgets = [];

  for (var document in documents) {
    Map<String, dynamic>? userData = document.data() as Map<String, dynamic>?;

    String? studentEmail = userData?['email'] as String?;
    String? role = userData?['role'] as String?;
    String? studentName = userData?['name'] as String?;

    if (role == 'Student') {
      studentWidgets.add(
        ListTile(
          title: Text(studentName ?? ''),
          subtitle: Text(studentEmail ?? ''),
          onTap: () {
            showStudentDetails(document);
          },
        ),
      );
    }
  }

  return studentWidgets;
}

Future<void> showStudentDetails(QueryDocumentSnapshot studentSnapshot) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String studentEmail = studentSnapshot['email'] as String;

    CollectionReference progressRef = firestore.collection('progress');
    QuerySnapshot progressSnapshot = await progressRef
        .where('email', isEqualTo: studentEmail)
        .get();

    List<Map<String, dynamic>> quizScores = [];

    for (var progressDoc in progressSnapshot.docs) {
      Map<String, dynamic>? progressData =
          progressDoc.data() as Map<String, dynamic>?;
      quizScores.add(progressData!);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Student Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: $studentEmail'),
              Text('Quiz Scores:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: quizScores.length,
                itemBuilder: (context, index) {
                  String? guardianEmail =
                      quizScores[index]['guardianEmail'] as String?;
                  int? score = quizScores[index]['score'] as int?;
                  return ListTile(
                    title: Text('Guardian Email: $guardianEmail'),
                    subtitle: Text('Score: $score'),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                sendEmailToGuardian(studentEmail);
              },
              child: Text('Email Guardian'),
            ),
            TextButton(
              onPressed: () async {
                await deleteSelectedStudents(studentEmail);
                Navigator.of(context).pop();
              },
              child: Text('Delete Student'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Error retrieving student details: $e');
  }
}
Future<void> sendEmailToGuardian(String studentEmail) async {
  // Implement the code to send an email to the guardian here
  // You can use the FlutterEmailSender package or any other email-related code

  // Example using FlutterEmailSender package:
  // final Email email = Email(
  //   recipients: [guardianEmail],
  //   subject: 'Regarding Your Child',
  //   body: 'Dear Guardian,\n\n...',
  // );
  // await FlutterEmailSender.send(email);
}



Future<void> deleteSelectedStudents(String studentEmail) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersRef = firestore.collection('users');

    QuerySnapshot querySnapshot = await usersRef
        .where('email', isEqualTo: studentEmail)
        .where('role', isEqualTo: 'Student')
        .get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (var document in documents) {
      await document.reference.delete();
    }

    // Delete progress documents
    CollectionReference progressRef = firestore.collection('progress');
    QuerySnapshot progressSnapshot =
        await progressRef.where('email', isEqualTo: studentEmail).get();

    for (var progressDoc in progressSnapshot.docs) {
      await progressDoc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Student deleted successfully.'),
      ),
    );

    // Refresh student list
    showRegisteredStudents(context);
  } catch (e) {
    print('Error deleting student: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting student.'),
      ),
    );
  }
}


Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
  } catch (e) {
    ErrorHandler.showErrorDialog(context, 'Error logging out: $e');
  }
}
}