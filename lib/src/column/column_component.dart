import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

import 'package:slack_reports/src/card/card.dart';
import 'package:slack_reports/src/column/column.dart';
import 'package:slack_reports/src/card/card_component.dart';

@Component(
  selector: 'emx-column',
  templateUrl: 'column_component.html',
  styleUrls: const ['column_component.css'],
  directives: const [CORE_DIRECTIVES, CardComponent],
)


class ColumnComponent {
  bool addingCard = false;

  @Input() Column column;
  @Input() List<Card> cards;
  @Input() List<Card> projects;

  final StreamController _addCardEvent = new StreamController<Card>();
  final StreamController _deleteCardEvent = new StreamController<Card>();
  final StreamController _updateCardEvent = new StreamController<Card>();
  final StreamController _attachProjectEvent = new StreamController<Card>();

  @Output() Stream<Card> get addCardEvent => _addCardEvent.stream;
  @Output() Stream<Card> get deleteCardEvent => _deleteCardEvent.stream;
  @Output() Stream<Card> get updateCardEvent => _updateCardEvent.stream;
  @Output() Stream<Card> get attachProjectEvent => _attachProjectEvent.stream;

  deleteCard(Card card) => _deleteCardEvent.add(card);
  updateCard(Card card) => _updateCardEvent.add(card);
  attachProject(Card card) => _attachProjectEvent.add(card);

  List<Card> filteredCards() {
    List<Card> cards = this.cards.where(
      (Card card) => (card.columnId == this.column.id && card.id.isNotEmpty)
    ).toList();

    cards.sort((a, b) => a.order.compareTo(b.order));

    return cards;
  }

  void addCard(String title) {
    if (!title.trim().isEmpty) {
      _addCardEvent.add(new Card.fromForm(title, this.column.id));
    }
    this.addingCard = false;
  }

  void enableAddCard() {
    this.addingCard = true;

    new Future.delayed(const Duration(milliseconds: 50), () => querySelector('#add-${this.column.id}').focus());
  }
}
