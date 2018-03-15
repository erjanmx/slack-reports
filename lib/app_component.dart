import 'package:angular/angular.dart';

import 'package:slack_reports/src/board.dart';
import 'package:slack_reports/src/card.dart';
import 'package:slack_reports/src/column.dart';
import 'package:slack_reports/src/column_component.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, ColumnComponent],
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
      new Card(1, 'Test-1', 1, 0, 1),
      new Card(2, 'Test-2', 2, 0, 1),
      new Card(3, 'Test-3', 2, 1, 1),
      new Card(4, 'Test-4', 2, 2, 1),
      new Card(5, 'Test-5', 3, 0, 2),
      new Card(6, 'Test-6', 3, 0, 0),
    ];

    this.board.projects = [
      new Card(1, 'Project-1', 0, 1, 0),
      new Card(2, 'Project-2', 0, 2, 1),
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
}
