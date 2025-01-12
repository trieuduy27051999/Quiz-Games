import 'package:easy_quiz_game/src/models/enums.dart';
import 'dart:convert';

class QuizCategory {
  final String name;
  final String description;
  final String iconImage;
  final QuizDifficulty difficulty;
  final List<Quiz> quizzes;

  QuizCategory({
    required this.name,
    required this.description,
    required this.iconImage,
    required this.difficulty,
    required this.quizzes,
  });

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    var quizzesJson = json['quizzes'] as List;
    List<Quiz> quizzesList = quizzesJson.map((quizJson) => Quiz.fromJson(quizJson)).toList();

    return QuizCategory(
      name: json['name'] as String,
      description: json['description'] as String,
      iconImage: json['iconImage'] as String,
      difficulty: QuizDifficulty.values.firstWhere(
            (e) => e.toString() == 'QuizDifficulty.' + json['difficulty'],
      ),
      quizzes: quizzesList,
    );
  }
}

class Quiz {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;
  final QuizQuestionType questionType;
  final QuizDifficulty difficulty;

  Quiz({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
    required this.questionType,
    required this.difficulty,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'] as int,
      hint: json['hint'] as String,
      questionType: QuizQuestionType.values.firstWhere(
            (e) => e.toString() == 'QuizQuestionType.' + json['questionType'],
      ),
      difficulty: QuizDifficulty.values.firstWhere(
            (e) => e.toString() == 'QuizDifficulty.' + json['difficulty'],
      ),
    );
  }
}

