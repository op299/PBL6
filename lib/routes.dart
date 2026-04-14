import 'package:flutter/material.dart';

import 'pages/conversations.dart';
import 'pages/dashboard.dart' show DashboardPage;
import 'pages/grammar.dart';
import 'pages/vocabulary.dart';
import 'realtimewebsocket/presentation/pages/web_socket_page.dart';
import 'package:pbl/pages/dashboard.dart';
import 'package:pbl/pages/quiz_page.dart';
import 'package:pbl/pages/vocabulary.dart';
import 'package:pbl/pages/grammar.dart';
import 'package:pbl/pages/conversations.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String vocabulary = '/vocabulary';
  static const String grammar = '/grammar';
  static const String conversations = '/conversations';
  static const String quiz = '/quiz';
  static const String settings = '/settings';
  static const String webSocket = '/websocket';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      dashboard: (context) => const DashboardPage(),
      vocabulary: (context) => const VocabularyPage1(),
      grammar: (context) => const GrammarPage(),

      conversations: (context) => const ConversationsPage(),
      webSocket: (context) => WebSocketPage(),
      
      quiz: (context) => const QuizPage(),
    };
  }
}
