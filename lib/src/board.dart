import 'dart:html';

import 'dart:convert' show JSON;

import 'package:slack_reports/src/lib/uuid.dart' ;

import 'package:slack_reports/src/card/card.dart';
import 'package:slack_reports/src/column/column.dart';

class Board {
  String name;

  final List<Column> columns = [
    new Column(1, 'Todo'),
    new Column(2, 'Doing'),
    new Column(3, 'Done'),
  ];

  final Column projectColumn = new Column(0, 'Projects');

  List<Card> cards = [];
  List<Card> projects = [];

  final Map<int, String> statuses = {
    1: 'НЕ СДЕЛАНО',
    2: 'В ПРОЦЕССЕ',
    3: 'СДЕЛАНО',
  };

  final List<String> colors = ['',
    '#00FFFF', '#5F9EA0', '#FF8C00', '#FF1493', '#228B22', '#20B2AA', '#9370DB',
    '#C71585', '#FFA500', '#4169E1',
  ];


  bool eveningReport = true;

  Board(this.name);

  String getCardWithStatus(Card card) {
    if (!this.eveningReport) {
      if (card.columnId == 3) {
        return '';
      }

      return '${card.title}\n';
    }

    return '${card.title} - ${this.statuses[card.columnId]}\n';
  }

  String build(List<Card> cards, [String projectName]) {
    String output = '';

    if (cards.isEmpty) {
      return output;
    }

    // sort by column and by order
    cards.sort((a, b) {
      if (a.columnId == b.columnId) {
        return a.order.compareTo(b.order);
      } else {
        return -a.columnId.compareTo(b.columnId);
      }
    });

    // do not include 'done' tasks in morning reports
    if (projectName != null && (this.eveningReport || cards.any((card) => card.columnId != 3))) {
      output = '- ${projectName}\n';
    }

    for (Card card in cards) {
      if (this.eveningReport) {
        output += '${card.title} - ${this.statuses[card.columnId]}\n';
      } else {
        if (card.columnId == 3) {
          continue;
        }

        output += '${card.title}\n';
      }
    }

    return output + (output.isEmpty ? '' : '\n');
  }


  @override
  String toString() {
    String output = '';

    this.projects.sort((a, b) => a.order.compareTo(b.order));

    this.projects.forEach((Card project) {
      List<Card> projectCards = this.cards.where((Card card) => (card.projectId == project.id && project.id.isNotEmpty)).toList();
      output += this.build(projectCards, project.title);
    });
    List<Card> nonProjectCards = this.cards.where((Card card) => (card.projectId.isEmpty)).toList();
    output += this.build(nonProjectCards);

    return output.trim();
  }

  Card getCardById(String id) => this.cards.firstWhere((Card card) => card.id == id);
  Card getProjectById(String id) => this.projects.firstWhere((Card card) => card.id == id);

  void save() {
    window.localStorage[this.name] = JSON.encode({
      'cards': this.cards,
      'projects': this.projects,
    });
  }

  void load() {
    var jsonList = window.localStorage[this.name];

    try {
      Map<String, List> board = JSON.decode(jsonList);

      this.cards = board['cards'].map((item) => new Card.fromJson(item)).toList();
      this.projects = board['projects'].map((item) => new Card.fromJson(item)).toList();
    } catch (e) {
      print(e);
      this.getSampleBoard();
    }
  }

  void add(Card card) {
    if (card.isProject()) {

      // attach new color
      // todo this with list functions
      List<String> existingColors = this.projects.map((Card card) => card.id);
      for (String color in this.colors) {
        if (!existingColors.contains(color)) {
          card.id = color;
          break;
        }
      }

      this.projects.add(card);
      return;
    }

    this.cards.add(card);
  }

  void delete(Card card) {
    if (!card.isProject()) {
      this.cards.remove(card);

      return;
    }

    this.cards = this.cards.map((Card c) {
      if (c.projectId == card.id) {
        c.unsetProject();
      }
      return c;
    }).toList();

    this.projects.remove(card);
  }

  void getSampleBoard() {
    this.cards = [
      new Card(uuid(), 'Task-1', 1, 1, '#00FFFF'),
      new Card(uuid(), 'Task-2', 1, 0, '#00FFFF'),
      new Card(uuid(), 'Task-3', 2, 0, '#5F9EA0'),
      new Card(uuid(), 'Task-4', 2, 1, '#5F9EA0'),
      new Card(uuid(), 'Task-5', 3, 0, '#FF8C00'),
    ];

    this.projects = [
      new Card('', '-', 0, 0, ''),
      new Card('#00FFFF', 'Project-1', 0, 1, ''),
      new Card('#5F9EA0', 'Project-2', 0, 2, ''),
      new Card('#FF8C00', 'Project-3', 0, 3, ''),
    ];
  }
}
