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

  bool addingCard = false;

  final StreamController _projectRemovedEvent = new StreamController<Card>();
  @Output()
  Stream<Card> get projectRemovedEvent => _projectRemovedEvent.stream;


  List<Card> filteredCards() {
    return this.cards.where(
      (Card card) => (card.columnId == this.column.id)
    ).toList();
  }

  void addCard(String title) {
    if (!title.trim().isEmpty) {
      this.cards.add(new Card(1, title, this.column.id, 1));
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
    // we might not need this
    this.cards[card.id] = card;
  }
}
