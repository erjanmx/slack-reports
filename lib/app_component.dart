import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;

import 'package:slack_reports/src/board.dart';
import 'package:slack_reports/src/card/card.dart';
import 'package:slack_reports/src/column/column_component.dart';

import 'package:slack_reports/src/lib/assortment.dart';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, ColumnComponent, MaterialToggleComponent,
    MaterialRippleComponent, formDirectives
  ],
)

class AppComponent {
  Board board;

  String slackChannel = '';
  String slackAuthToken = '';

  Assortment taskAssortment;
  Assortment projectAssortment;

  final String title = 'Dashboard';
  final String version = '0.1.0';

  AppComponent() {
    board = new Board('${this.title}-${this.version}');

    initializeBoard();

    checkSlackAuth();
  }

  void initializeBoard() {
    this.board.load();

    new Future.delayed(const Duration(milliseconds: 500), () => setupView());
  }

  void reload() {
    this.board.save();

    initializeBoard();
  }

  deleteCard(Card card) {
    this.board.delete(card);

    this.reload();
  }

  void addCard(Card card) {
    this.board.add(card);

    this.reload();
  }

  setupView() {
    taskAssortment = new Assortment(
        querySelectorAll('.task-cards'),
        querySelectorAll('.task-card')
    );
    projectAssortment = new Assortment(
        querySelectorAll('.project-cards'),
        querySelectorAll('.project-card')
    );

    taskAssortment.onDragEnd.listen((Element element) {
      List<Element> taskCards = querySelectorAll('.task-card');

      int c_id = 0;
      int order = 0;
      for (Element taskCard in taskCards) {
        Card card = board.getCardById(taskCard.getAttribute('data-card-id'));
        int col_id = int.parse(taskCard.parent.getAttribute('data-column-id'));

        card.columnId = col_id;

        if (c_id != col_id) order = 0;

        c_id = col_id;
        card.order = order++;
      };

      this.reload();
    });

    projectAssortment.onDragEnd.listen((Element element) {
      List<Element> projectCards = querySelectorAll('.project-card');

      int order = 0;
      for (Element projectCard in projectCards) {
        board.getProjectById(projectCard.getAttribute('data-card-id')).order = order++;
      };

      this.reload();
    });
  }

  bool authorized() {
    return this.slackAuthToken.isNotEmpty;
  }

  void checkSlackAuth()
  {
    var channel = window.localStorage['slack_channel'];
    var authTokenString = window.localStorage['slack_auth_key'];

    if (authTokenString == null) {
      this.slackAuthToken = '';
      return;
    }

    var tokenArray = JSON.decode(authTokenString);

    if (tokenArray['ok'] == false) {
      this.slackAuthToken = '';
      return;
    }

    if (channel == null) {
      channel = '';
    }

    this.slackChannel = channel;
    this.slackAuthToken = tokenArray['access_token'];
  }


  void sendToSlack()
  {
    String postUrl = 'https://slack.com/api/chat.postMessage';
    String text = querySelector('#text').value;
    window.localStorage['slack_channel'] = this.slackChannel;


    var data = {
      'text' : text,
      'as_user' : 'true',
      'token': this.slackAuthToken,
      'channel' : this.slackChannel,
    };

    HttpRequest.postFormData(postUrl, data).then((HttpRequest resp) {
      var r = JSON.decode(resp.responseText);

      print(r);

      if (r['ok'] == false) {
        window.alert(r['error']);
      }
    });
  }
}
