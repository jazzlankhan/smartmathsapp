import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hard Screen'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedIconButton(
              icon: Icons.assignment,
              text: 'Practice Questions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HardPracticeQuestions(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            RoundedIconButton(
              icon: Icons.quiz,
              text: 'Quiz',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HardQuizScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            RoundedIconButton(
              icon: Icons.video_library,
              text: 'Animations and Rhymes',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HardAnimationsAndRhymes(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HardPracticeQuestions extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Questions'),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('practice_questions').doc('hard').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final questions = snapshot.data!.data() as Map<String, dynamic>?;

            if (questions == null) {
              return Text('No practice questions available.');
            }

            return ListView(
              children: questions.entries.map((entry) {
                final question = entry.key;
                final answer = entry.value;

                return ListTile(
                  title: Text(question),
                  subtitle: Text('Answer: $answer'),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class HardQuizScreen extends StatefulWidget {
  @override
  _HardQuizScreenState createState() => _HardQuizScreenState();
}

class _HardQuizScreenState extends State<HardQuizScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      question: 'What is the result of 24 ÷ 3?',
      options: ['6', '8', '12', '16'],
      correctAnswer: '8',
    ),
    QuizQuestion(
      question: 'Which of the following is an integer?',
      options: ['3/4', '-2/3', '1/2', '5/6'],
      correctAnswer: '-2/3',
    ),
    // Add more quiz questions here
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Screen'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              quizQuestions[currentQuestionIndex].question,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ...quizQuestions[currentQuestionIndex]
                .options
                .map((option) => ElevatedButton(
                      onPressed: () {
                        checkAnswer(option);
                      },
                      child: Text(option),
                    ))
                .toList(),
            SizedBox(height: 20),
            Text(
              'Score: $score / ${quizQuestions.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (currentQuestionIndex < quizQuestions.length - 1)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentQuestionIndex++;
                  });
                },
                child: Text('Next Question'),
              ),
            if (currentQuestionIndex == quizQuestions.length - 1)
              ElevatedButton(
                onPressed: () {
                  saveQuizScoreAndDetails();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Quiz Complete'),
                        content: Text('Your score: $score / ${quizQuestions.length}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Finish Quiz'),
              ),
          ],
        ),
      ),
    );
  }

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == quizQuestions[currentQuestionIndex].correctAnswer) {
      setState(() {
        score++;
      });
    }
  }

  void saveQuizScoreAndDetails() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String studentId = user.uid;
      final String studentEmail = user.email ?? '';
      final String studentName = user.displayName ?? '';

      FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          final guardianEmail = snapshot.data()?['guardianEmail'] as String?;

          FirebaseFirestore.instance
              .collection('progress')
              .doc(studentId)
              .set({
            'email': studentEmail,
            'name': studentName,
            'guardianEmail': guardianEmail,
            'score': score,
          })
              .then((value) {
            print('Score and details saved successfully');
          })
              .catchError((error) {
            print('Failed to save score and details: $error');
          });
        }
      });
    }
  }
}

class HardAnimationsAndRhymes extends StatelessWidget {
  final List<VideoData> videos = [
    VideoData(
      heading: 'Integers - Division',
      videoUrl: 'https://youtube.com/watch?v=rGMecZ_aERo&feature=share',
    ),
    VideoData(
      heading: 'Integers - Division',
      videoUrl: 'https://youtube.com/watch?v=le_OE27ysuU&feature=share',
    ),
    VideoData(
      heading: 'Integers - Division',
      videoUrl: 'https://youtube.com/watch?v=oF2fITujB4c&feature=share',
    ),
    VideoData(
      heading: 'Integer Operations',
      videoUrl: 'https://youtu.be/Gr3BTEyEKP0',
    ),
    VideoData(
      heading: 'Integer Operations',
      videoUrl: 'https://youtu.be/O6bRgxVRoZ4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animations and Rhymes'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(videos[index].heading),
              leading: Icon(Icons.play_arrow),
              onTap: () {
                // Open video player with the corresponding URL
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoUrl: videos[index].videoUrl),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class VideoData {
  final String heading;
  final String videoUrl;

  VideoData({required this.heading, required this.videoUrl});
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
            flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          progressColors: ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const RoundedIconButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
