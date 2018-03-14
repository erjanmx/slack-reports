import 'package:angular/angular.dart';

import 'package:slack_reports/src/column.dart';
import 'package:slack_reports/src/column_component.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, ColumnComponent],
)

class AppComponent {
  final title = 'Dashboard';

  final List<Column> columns = [
    new Column(1, 'Todo'),
    new Column(2, 'Doing'),
    new Column(3, 'Done'),
  ];
}
