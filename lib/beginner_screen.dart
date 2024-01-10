import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BeginnerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner Screen'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeginnerPracticeQuestions(),
                  ),
                );
              },
              icon: Icon(Icons.question_answer),
              label: Text('Practice Questions'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeginnerQuizScreen(),
                  ),
                );
              },
              icon: Icon(Icons.quiz),
              label: Text('Quiz'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeginnerAnimationsAndRhymes(),
                  ),
                );
              },
              icon: Icon(Icons.animation),
              label: Text('Animations and Rhymes'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BeginnerPracticeQuestions extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Questions'),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('practice_questions').doc('beginner').snapshots(),
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

class BeginnerQuizScreen extends StatefulWidget {
  @override
  _BeginnerQuizScreenState createState() => _BeginnerQuizScreenState();
}

class _BeginnerQuizScreenState extends State<BeginnerQuizScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      question: 'How many fingers do you have?',
      options: ['5', '8', '10', '12'],
      correctAnswer: '10',
    ),
    QuizQuestion(
      question: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
      correctAnswer: '4',
    ),
    // Add more quiz questions here
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner Quiz Screen'),
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
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
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
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
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
          final guardianName = snapshot.data()?['guardianName'] as String?;

          FirebaseFirestore.instance
              .collection('progress')
              .doc(studentId)
              .set({
            'email': studentEmail,
            'name': studentName,
            'guardianEmail': guardianEmail,
            'guardianName': guardianName,
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

class BeginnerAnimationsAndRhymes extends StatelessWidget {
  final List<VideoInfo> videos = [
    VideoInfo(
      videoUrl: 'https://www.youtube.com/watch?v=zBQH59TtMcs',
      heading: '1 to 10',
    ),
    VideoInfo(
      videoUrl: 'https://www.youtube.com/watch?v=2QbhUscTAVw',
      heading: '11 to 20',
    ),
    VideoInfo(
      videoUrl: 'https://www.youtube.com/watch?v=y3GynqBwV1M',
      heading: '1 to 100',
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
            return VideoPlayerWidget(
              videoUrl: videos[index].videoUrl,
              heading: videos[index].heading,
            );
          },
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String heading;

  const VideoPlayerWidget({required this.videoUrl, required this.heading});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.heading,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          progressColors: ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
          onReady: () {
            print('Player is ready.');
          },
        ),
      ],
    );
  }
}

class VideoInfo {
  final String videoUrl;
  final String heading;

  VideoInfo({required this.videoUrl, required this.heading});
}

void main() {
  runApp(MaterialApp(
    home: BeginnerScreen(),
  ));
}
