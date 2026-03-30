import 'package:flutter/material.dart';
import 'package:pbl/pages/dashboard.dart';
import 'package:pbl/pages/vocabulary.dart';
import 'package:pbl/pages/grammar.dart';
import 'package:pbl/pages/conversations.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String vocabulary = '/vocabulary';
  static const String grammar = '/grammar';
  static const String conversations = '/conversations';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      dashboard: (context) => const DashboardPage(),
      vocabulary: (context) => const VocabularyPage(),
      grammar: (context) => const GrammarPage(),
      conversations: (context) => const ConversationsPage(),
    };
  }
}
