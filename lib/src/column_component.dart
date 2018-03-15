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
  List<Card> cards = [new Card(1, 'New card', 2, 1)];

  bool addingCard = false;

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
    this.cards.remove(card);
  }

  void updateCard(Card card) {
    print('updated');
    this.cards.add(card);
  }
}
