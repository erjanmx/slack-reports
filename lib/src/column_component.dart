import 'package:angular/angular.dart';

import 'package:slack_reports/src/column.dart';

@Component(
  selector: 'emx-column',
  templateUrl: 'column_component.html',
  styleUrls: const ['column_component.css'],
  directives: const [CORE_DIRECTIVES],
)


class ColumnComponent {
  @Input()
  Column column;

  bool addingCard = false;
}
