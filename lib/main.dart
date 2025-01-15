import 'package:flutter/material.dart';
import 'package:easy_quiz_game/easy_quiz_game.dart';
import 'package:quizgame/socket_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  final socketService = SocketService();
  socketService.connect();

  runApp(MyApp(socketService: socketService));
}

class MyApp extends StatelessWidget {
  final SocketService socketService;
  const MyApp({Key? key, required this.socketService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<QuizCategory>> fetchQuizCategories() async {
    final response =
        await http.get(Uri.parse('https://game.tuan-anh-sd.software/quiz-set'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      List<QuizCategory> categories = [];

      for (var category in data) {
        final quizzes = await fetchQuizzes(category['_id']);
        categories.add(QuizCategory(
          name: category['event'],
          description: category['description'],
          iconImage:
              'assets/images/${category['event'].toLowerCase().replaceAll(' ', '_')}.png',
          difficulty: QuizDifficulty.values.firstWhere(
              (e) => e.toString().split('.').last == category['difficulty']),
          quizzes: quizzes,
        ));
      }

      return categories;
    } else {
      throw Exception('Failed to load quiz categories');
    }
  }

  Future<List<Quiz>> fetchQuizzes(String categoryId) async {
    final response = await http.get(Uri.parse(
        'https://game.tuan-anh-sd.software/quiz-set/$categoryId/questions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data
          .map((quiz) => Quiz(
                question: quiz['question'],
                options: List<String>.from(quiz['options']),
                correctIndex: quiz['correctIndex'],
                hint: quiz['hint'],
                questionType: QuizQuestionType.values.firstWhere((e) =>
                    e.toString().split('.').last == quiz['questionType']),
                difficulty: QuizDifficulty.values.firstWhere(
                    (e) => e.toString().split('.').last == quiz['difficulty']),
              ))
          .toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  Widget getGameWidget(BuildContext context) {
    return FutureBuilder<List<QuizCategory>>(
      future: fetchQuizCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No quizzes available'));
        } else {
          return EasyQuizGameApp(
            quizCategories: snapshot.data!,
            primaryColor: Colors.orange.shade300,
            menuLogoPath: 'assets/images/game_logo.png',
            buttonPath: 'assets/images/primary_button.png',
            labelPath: 'assets/images/label.png',
            bgImagePath: 'assets/images/bg.png',
            gradient: LinearGradient(
              stops: const [0, 1],
              begin: const Alignment(1, -1),
              end: const Alignment(0, 1),
              colors: [Theme.of(context).primaryColor, const Color(0xff753bc6)],
            ),
            secondaryColor: const Color(0xff753bc6),
          );
        }
      },
    );
  }

  void onPressedStandalone() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(body: getGameWidget(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getGameWidget(context),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedStandalone,
        tooltip: 'Launch standalone',
        child: const Icon(Icons.launch),
      ),
    );
  }
}
