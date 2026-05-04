import 'package:flutter/material.dart';

import 'package:pbl/pages/dashboard.dart';
import 'package:pbl/pages/login_page.dart';
import 'package:pbl/pages/quiz_page.dart';
import 'package:pbl/pages/register_page.dart';
import 'package:pbl/pages/vocabulary.dart';
import 'package:pbl/pages/grammar.dart';
import 'package:pbl/pages/conversations.dart';
import 'package:pbl/pages/profile_page.dart';
import 'package:pbl/history/presentation/page/history_page.dart';
import 'realtimewebsocket/presentation/pages/web_socket_page.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String vocabulary = '/vocabulary';
  static const String grammar = '/grammar';
  static const String conversations = '/conversations';
  static const String quiz = '/quiz';
  static const String profile = '/profile'; // Thêm route cho ProfilePage
  static const String settings = '/settings';
  static const String webSocket = '/websocket';
  static const String history = '/history';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      dashboard: (context) => const DashboardPage(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      vocabulary: (context) => const VocabularyPage1(),
      grammar: (context) => const GrammarPage(),
      conversations: (context) => const ConversationsPage(),
      webSocket: (context) => WebSocketPage(),
      quiz: (context) => const QuizPage(),
      profile: (context) => const ProfilePage(),
      history: (context) => const HistoryPage(),
    };
  }
}
