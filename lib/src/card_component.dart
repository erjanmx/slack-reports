import 'dart:async';
import 'package:angular/angular.dart';

import 'package:slack_reports/src/card.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'emx-card',
  templateUrl: 'card_component.html',
  styleUrls: const ['card_component.css'],
  directives: const [CORE_DIRECTIVES, MaterialIconComponent],
)


class CardComponent {
  @Input()
  Card card;

  final _cardRemovedEvent = new StreamController<Card>();
  @Output() Stream<Card> get cardRemovedEvent => _cardRemovedEvent.stream;

  bool editingCard = false;

  void deleteCard() {
    _cardRemovedEvent.add(this.card);
  }

  void editCard() {
    this.editingCard = true;


  }

  void updateCard(String title) {
    this.card.title = title;
    this.editingCard = false;
  }

  void cancelEditCard() {
    this.editingCard = false;
  }
}
