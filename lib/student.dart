import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';
import 'beginner_screen.dart';
import 'intermediate_screen.dart';
import 'hard_screen.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _levelSelected = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void _saveLevelToDatabase(String level) {
    // Save the selected level to the database for the current user
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersRef = firestore.collection('users');
    usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'level': level})
        .then((value) {
      print('Level saved successfully');
    }).catchError((error) {
      print('Failed to save level: $error');
    });
  }

  void _navigateToLevelScreen(String level) {
    setState(() {
      _levelSelected = true;
    });

    Future.delayed(Duration.zero, () {
      if (level == 'Beginner') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BeginnerScreen(),
          ),
        );
      } else if (level == 'Intermediate') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IntermediateScreen(),
          ),
        );
      } else if (level == 'Hard') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HardScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_levelSelected) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Student"),
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
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _startAnimation();
                      _saveLevelToDatabase('Beginner');
                      _navigateToLevelScreen('Beginner');
                    },
                    icon: Icon(Icons.star),
                    label: Text(
                      "Beginner",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _startAnimation();
                      _saveLevelToDatabase('Intermediate');
                      _navigateToLevelScreen('Intermediate');
                    },
                    icon: Icon(Icons.star),
                    label: Text(
                      "Intermediate",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _startAnimation();
                      _saveLevelToDatabase('Hard');
                      _navigateToLevelScreen('Hard');
                    },
                    icon: Icon(Icons.star),
                    label: Text(
                      "Hard",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
