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

  final StreamController _projectRemovedEvent = new StreamController<Card>();
  final StreamController _addCardEvent = new StreamController<Card>();

  @Output()
  Stream<Card> get projectRemovedEvent => _projectRemovedEvent.stream;
  @Output()
  Stream<Card> get addCardEvent => _addCardEvent.stream;


  List<Card> filteredCards() {
    return this.cards.where(
      (Card card) => (card.columnId == this.column.id)
    ).toList();
  }

  void addCard(String title) {
    if (!title.trim().isEmpty) {
      _addCardEvent.add(new Card(
          this.cards.length + 1, title, this.column.id, 999, 0
      ));
    }
    this.addingCard = false;
  }

  void enableAddCard() {
    this.addingCard = true;
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
}
