import 'package:angular/angular.dart';

import 'package:slack_reports/src/card.dart';

@Component(
  selector: 'emx-card',
  templateUrl: 'card_component.html',
  styleUrls: const ['card_component.css'],
  directives: const [CORE_DIRECTIVES],
)


class CardComponent {
  @Input()
  Card card;

  bool editingCard = false;
}
