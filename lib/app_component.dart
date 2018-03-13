import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

//import 'package:slack_reports/column_component.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, formDirectives],
)

class AppComponent {
  final title = 'Dashboard';

  final List columns = ['Todo', 'Doing', 'Done'];
}
