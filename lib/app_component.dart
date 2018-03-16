import 'dart:html';
import 'package:angular/angular.dart';

import 'package:slack_reports/src/uuid.dart';
import 'package:slack_reports/src/board.dart';
import 'package:slack_reports/src/card.dart';
import 'package:slack_reports/src/column.dart';
import 'package:slack_reports/src/column_component.dart';
import 'package:angular_components/angular_components.dart';

import 'dart:convert' show JSON;

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, ColumnComponent, MaterialToggleComponent],
)

class AppComponent {
  final title = 'Dashboard';

  final String version = '0.1.0';

  Board board = new Board();

  void initLocalStorage() {
    var jsonList = window.localStorage['slack-reports-${this.version}'];
    try {
      Map<String, List> board = JSON.decode(jsonList);

      board['cards'].forEach((c) {
        this.board.cards.add(new Card(c['id'], c['title'], c['order'], c['projectId']));
      });
      board['projects'].forEach((c) {
        this.board.projects.add(new Card(c['id'], c['title'], c['order'], c['projectId']));
      });

    } catch (e) {

      print(e);
      this.board.cards = [
        new Card(uuid(), 'Task-1', 1, 0, 1),
        new Card(uuid(), 'Task-2', 2, 1, 1),
        new Card(uuid(), 'Task-3', 1, 0, 2),
        new Card(uuid(), 'Task-4', 2, 1, 2),
        new Card(uuid(), 'Task-5', 3, 0, 0),
      ];

      this.board.projects = [
        new Card(uuid(), '-', 0, 0, 0),
        new Card(uuid(), 'Project-1', 0, 1, 0),
        new Card(uuid(), 'Project-2', 0, 2, 0),
        new Card(uuid(), 'Project-3', 0, 3, 0),
      ];
    }
  }

  void save() {
    Map<String, List<Card>> list = {
      'cards': this.board.cards,
      'projects': this.board.projects,
    };

    window.localStorage['slack-reports-${this.version}'] = JSON.encode(list);
  }


  AppComponent() {
    this.board.columns = [
      new Column(1, 'Todo'),
      new Column(2, 'Doing'),
      new Column(3, 'Done'),
    ];

    this.initLocalStorage();
  }

  deleteProject(Card card) {
    this.board.cards = this.board.cards.map((Card c) {
      if (c.projectId == card.id) {
        c.projectId = 0;
      }
     return c;
    }).toList();
  }

  void addCard(Card card) {
    if (card.columnId == 0) {
      card.order = this.board.projects.length + 1;
      this.board.projects.add(card);
    } else {
      this.board.cards.add(card);
    }
  }

  void attachProject(Card card) {
    this.board.cards = this.board.cards.map((Card c) {
      if (c.id == card.id) {
        c.projectId = card.projectId;
      }
      return c;
    }).toList();

    this.save();
  }
}
