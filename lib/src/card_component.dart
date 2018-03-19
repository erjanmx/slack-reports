import 'dart:html';
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
  final StreamController _cardAttachProjectEvent = new StreamController<Card>();

  @Output()
  Stream<Card> get cardRemovedEvent => _cardRemovedEvent.stream;
  @Output()
  Stream<Card> get cardUpdatedEvent => _cardUpdatedEvent.stream;
  @Output()
  Stream<Card> get cardAttachProjectEvent => _cardAttachProjectEvent.stream;

  List<String> colors = ['',
    '#00FFFF', '#5F9EA0', '#FF8C00', '#FF1493',
    '#228B22', '#20B2AA', '#9370DB', '#C71585', '#FFA500', '#4169E1',
  ];

  bool editingCard = false;
  bool showingMenu = false;

  void deleteCard() {
    _cardRemovedEvent.add(this.card);
  }

  void editCard() {
    this.editingCard = true;

    new Future.delayed(const Duration(milliseconds: 50), () => querySelector('#edit-${this.card.id}').focus());
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

  String getCardColor() {
    if (this.card.projectId.isEmpty) {
      return '';
    }

    return this.colors[this.projects.where((Card card) => card.id == this.card.projectId).first.order];
  }

  void attachProject(String projectId) {
    this.card.projectId = projectId;

    _cardAttachProjectEvent.add(this.card);
    this.showingMenu = false;
  }
}
