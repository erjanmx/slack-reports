import 'package:angular/angular.dart';

import 'package:slack_reports/src/board.dart';
import 'package:slack_reports/src/card.dart';
import 'package:slack_reports/src/column.dart';
import 'package:slack_reports/src/column_component.dart';
import 'package:angular_components/angular_components.dart';


@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, ColumnComponent, MaterialToggleComponent],
)

class AppComponent {
  final title = 'Dashboard';

  Board board = new Board();

  AppComponent() {
    this.board.columns = [
      new Column(1, 'Todo'),
      new Column(2, 'Doing'),
      new Column(3, 'Done'),
    ];

    this.board.cards = [
      new Card(1, 'Task-1', 1, 0, 1),
      new Card(2, 'Task-2', 1, 0, 1),
      new Card(3, 'Task-3', 2, 2, 1),
      new Card(4, 'Task-4', 2, 2, 1),
      new Card(5, 'Task-5', 3, 0, 1),
      new Card(6, 'Task-6', 3, 0, 2),
      new Card(7, 'Task-7', 2, 0, 2),
      new Card(8, 'Task-8', 2, 0, 2),
      new Card(9, 'Task-9', 2, 0, 3),
      new Card(10, 'Task-10', 3, 1, 3),
      new Card(11, 'Task-11', 1, 2, 0),
      new Card(12, 'Task-12', 2, 1, 0),
      new Card(13, 'Task-13', 3, 1, 0),
    ];

    this.board.projects = [
      new Card(0, '-', 0, 0, 0),
      new Card(1, 'Project-1', 0, 1, 0),
      new Card(2, 'Project-2', 0, 2, 0),
      new Card(3, 'Project-3', 0, 3, 0),
    ];
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
  }
}
