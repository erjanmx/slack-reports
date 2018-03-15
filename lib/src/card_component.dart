import 'dart:async';
import 'package:angular/angular.dart';

import 'package:slack_reports/src/card.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'emx-card',
  templateUrl: 'card_component.html',
  styleUrls: const ['card_component.css'],
  directives: const [CORE_DIRECTIVES, MaterialIconComponent, formDirectives],
)


class CardComponent {
  @Input()
  Card card;

  @Input()
  List<Card> projects;

  final StreamController _cardRemovedEvent = new StreamController<Card>();
  final StreamController _cardUpdatedEvent = new StreamController<Card>();

  @Output()
  Stream<Card> get cardRemovedEvent => _cardRemovedEvent.stream;
  @Output()
  Stream<Card> get cardUpdatedEvent => _cardUpdatedEvent.stream;

  List<String> colors = ['#61bd4f', '#f2d600', '#ffab4a', '#eb5a46',
    '#c377e0 ', '#0079bf', '#0079bf', '#00c2e0', '#51e898', '#ff80ce',
  ];

  bool editingCard = false;
  bool showingMenu = false;

  void deleteCard() {
    _cardRemovedEvent.add(this.card);
  }

  void editCard() {
    this.editingCard = true;
  }

  void updateCard() {
    _cardUpdatedEvent.add(this.card);
    this.editingCard = false;
  }

  void cancelEditCard() {
    this.editingCard = false;
  }

  String getColor() {
    if (this.card.columnId != 0 || this.card.order > this.colors.length) {
      return '';
    }

    return this.colors[this.card.order];
  }
}
