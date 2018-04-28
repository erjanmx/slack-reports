import 'dart:html';

import 'package:angular/angular.dart';
import 'package:slack_reports/app_component.dart';

String api_url = 'https://slack.com/api/oauth.access';
String base_url = 'https://erjanmx.github.io/slack-reports/';
String client_id = '14172408775.340791157783';
String client_secret='5e64751a9c639ff790e9e3d752bff9e5';

void main() {
  String code = Uri.base.queryParameters['code'];

  if (code != null && code.isNotEmpty) {
    save_slack_auth_key(code);
  }

  bootstrap(AppComponent);
}

void save_slack_auth_key(code) {
  String url = '$api_url?code=$code&client_id=$client_id&client_secret=$client_secret';

  HttpRequest.getString(url).then((responseText) {
    window.localStorage['slack_auth_key'] = responseText;
    window.location.replace(base_url);
  });
}
