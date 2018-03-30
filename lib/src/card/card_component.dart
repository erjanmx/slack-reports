import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

import 'package:slack_reports/src/card/card.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'emx-card',
  templateUrl: 'card_component.html',
  styleUrls: const ['card_component.css'],
  directives: const [CORE_DIRECTIVES, MaterialIconComponent, formDirectives],
)

class CardComponent {
  bool editingCard = false;
  bool showingMenu = false;

  final StreamController _cardRemovedEvent = new StreamController<Card>();
  final StreamController _cardUpdatedEvent = new StreamController<Card>();
  final StreamController _projectAttachEvent = new StreamController<Card>();

  @Input() Card card;
  @Input() List<Card> projects;

  @Output() Stream<Card> get cardRemovedEvent => _cardRemovedEvent.stream;
  @Output() Stream<Card> get cardUpdatedEvent => _cardUpdatedEvent.stream;
  @Output() Stream<Card> get projectAttachEvent => _projectAttachEvent.stream;

  deleteCard() => _cardRemovedEvent.add(this.card);

  void editCard() {
    this.editingCard = true;

    new Future.delayed(
        const Duration(milliseconds: 50), () => querySelector('#edit-${this.card.id}').focus()
    );
  }

  void updateCard() {
    this.card.title = this.card.title.trim();
    _cardUpdatedEvent.add(this.card);
    this.editingCard = false;
  }

  void cancelEditCard() {
    this.editingCard = false;
  }

  void attachProject(String projectId) {
    this.card.projectId = projectId;

    _projectAttachEvent.add(this.card);
    this.showingMenu = false;
  }
}
