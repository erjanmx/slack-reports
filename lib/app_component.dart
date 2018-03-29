import 'dart:html';
import 'dart:async';

import 'package:slack_reports/src/board.dart';
import 'package:slack_reports/src/card/card.dart';
import 'package:slack_reports/src/column/column_component.dart';

import 'package:slack_reports/src/lib/assortment.dart';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, ColumnComponent, MaterialToggleComponent],
)

class AppComponent {
  Board board;

  final String title = 'Dashboard';
  final String version = '0.1.0';

  AppComponent() {
    board = new Board('${this.title}-${this.version}');

    initializeBoard();
  }

  void initializeBoard() {
    this.board.load();

    new Future.delayed(const Duration(milliseconds: 500), () => setupView());
  }

  void reload() {
    this.board.save();

    initializeBoard();
  }

  deleteCard(Card card) {
    this.board.delete(card);

    this.reload();
  }

  void addCard(Card card) {
    this.board.add(card);

    this.reload();
  }

  setupView() {
    var a = new Assortment(querySelector('.task-cards'));
    a.addElements(querySelectorAll('.task-card'));

    var p = new Assortment(querySelector('.project-cards'));
    p.addElements(querySelectorAll('.project-card'));

    a.onDragEnd.listen((AssortmentEvent event) {
      List<Element> elements = querySelectorAll('.task-card');

      int i = 0;
      int c_id = 0;
      Card card;
      for (Element element in elements) {
        String card_id = element.getAttribute('data-card-id');
        int column_id = int.parse(element.parent.getAttribute('data-column-id'));

        card = board.getCardById(card_id);

        if (c_id != column_id) i = 0;

        card.columnId = column_id;
        card.order = i++;

        c_id = column_id;
      };

      this.reload();
    });

    p.onDragEnd.listen((AssortmentEvent event) {
      List<Element> elements = querySelectorAll('.project-card');

      int i = 0;
      Card card;
      for (Element element in elements) {
        String card_id = element.getAttribute('data-card-id');
        card = board.getProjectById(card_id);
        card.order = i++;
      };

      this.reload();
    });
  }

}
