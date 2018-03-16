import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

import 'package:slack_reports/src/card.dart';
import 'package:slack_reports/src/column.dart';
import 'package:slack_reports/src/card_component.dart';

@Component(
  selector: 'emx-column',
  templateUrl: 'column_component.html',
  styleUrls: const ['column_component.css'],
  directives: const [CORE_DIRECTIVES, CardComponent],
)


class ColumnComponent {
  @Input()
  Column column;

  @Input()
  List<Card> cards;

  @Input()
  List<Card> projects;

  bool addingCard = false;

  final StreamController _addCardEvent = new StreamController<Card>();
  final StreamController _projectRemovedEvent = new StreamController<Card>();
  final StreamController _projectAttachedEvent = new StreamController<Card>();

  @Output()
  Stream<Card> get addCardEvent => _addCardEvent.stream;
  @Output()
  Stream<Card> get projectRemovedEvent => _projectRemovedEvent.stream;
  @Output()
  Stream<Card> get projectAttachedEvent => _projectAttachedEvent.stream;


  List<Card> filteredCards() {
    return this.cards.where(
      (Card card) => (card.columnId == this.column.id && card.id != 0)
    ).toList();
  }

  void addCard(String title) {
    if (!title.trim().isEmpty) {
      int i = (this.column.id != 0) ? this.projects.length : this.cards.length;

      _addCardEvent.add(new Card(i + 1, title, this.column.id, 999, 0));
    }
    this.addingCard = false;
  }

  void enableAddCard() {
    this.addingCard = true;

    new Future.delayed(const Duration(milliseconds: 50), () => querySelector('#add-${this.column.id}').focus());
  }

  void deleteCard(Card card) {
    if (card.columnId == 0) {
      _projectRemovedEvent.add(card);
    }

    this.cards.remove(card);
  }

  void updateCard(Card card) {
    card.title = card.title.trim();
  }

  void attachProject(Card card) {
    _projectAttachedEvent.add(card);
  }
}
