import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

import 'package:slack_reports/src/uuid.dart';
import 'package:slack_reports/src/board.dart';
import 'package:slack_reports/src/card.dart';
import 'package:slack_reports/src/column.dart';
import 'package:slack_reports/src/column_component.dart';
import 'package:angular_components/angular_components.dart';

import 'dart:convert' show JSON;
//import 'package:js/js.dart' as js;
//import 'package:dnd/dnd.dart';
//import 'dart:js' as js;
import 'package:assortment/assortment.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, ColumnComponent, MaterialToggleComponent],
)

class AppComponent {
  final title = 'Dashboard';

  final String version = '0.1.0';

  Board board = new Board();

  void initLocalStorage() {
    var jsonList = window.localStorage['slack-reports-${this.version}'];
    try {
      throw new Exception();
      Map<String, List> board = JSON.decode(jsonList);

      this.board.cards = board['cards'].map((item) => new Card.fromJson(item)).toList();
      this.board.projects = board['projects'].map((item) => new Card.fromJson(item)).toList();
    } catch (e) {
      print(e);
      this.board.cards = [
        new Card(uuid(), 'Task-1', 1, 1, ''),
        new Card(uuid(), 'Task-2', 1, 0, ''),
        new Card(uuid(), 'Task-3', 2, 0, ''),
        new Card(uuid(), 'Task-4', 2, 1, ''),
        new Card(uuid(), 'Task-5', 3, 0, ''),
      ];

      this.board.projects = [
        new Card('', '-', 0, 0, ''),
        new Card(uuid(), 'Project-1', 0, 1, ''),
        new Card(uuid(), 'Project-2', 0, 2, ''),
        new Card(uuid(), 'Project-3', 0, 3, ''),
      ];
    }
  }

  void save() {
    Map<String, List<Card>> list = {
      'cards': this.board.cards,
      'projects': this.board.projects,
    };

    window.localStorage['slack-reports-${this.version}'] = JSON.encode(list);
  }


  AppComponent() {
    this.board.columns = [
      new Column(1, 'Todo'),
      new Column(2, 'Doing'),
      new Column(3, 'Done'),
    ];

    this.initLocalStorage();

    new Future.delayed(const Duration(milliseconds: 500), () => setupView());
  }

  deleteProject(Card card) {
    this.board.cards = this.board.cards.map((Card c) {
      if (c.projectId == card.id) {
        c.projectId = '';
      }
     return c;
    }).toList();
  }

  void addCard(Card card) {
    if (card.columnId == 0) {
      this.board.projects.add(card);
    } else {
      this.board.cards.add(card);
    }
  }

  void attachProject(Card card) {
    this.board.cards = this.board.cards.map((Card c) {
      if (c.id == card.id) {
        c.projectId = card.projectId;
      }
      return c;
    }).toList();

    this.save();
  }

//  void initDraggable() {
////      js.context.callMethod(r'$', ['#dialog']).callMethod('dialog');
////      js.context.$("#dialog").dialog();
//
//    // Install same elements as draggable and dropzone.
//    Draggable draggable = new Draggable(querySelectorAll('.sortable'),
//        avatarHandler: new AvatarHandler.clone());
//
//    Dropzone dropzone = new Dropzone(querySelectorAll('.sortable'));
//
//    // Swap elements when dropped.
//    dropzone.onDrop.listen((DropzoneEvent event) {
//
//      swapElements(event.draggableElement, event.dropzoneElement);
//    });
//  }

  void swapElements(Element elm1, Element elm2) {
//    Card card_1 = this.
    this.board.cards.first.columnId = 2;
    print(elm1.getAttribute('data-id'));
    print(elm2.getAttribute('data-id'));

//    new Future.delayed(const Duration(milliseconds: 500), () => initDraggable());
//    var parent1 = elm1.parent;
//    var next1   = elm1.nextElementSibling;
//    var parent2 = elm2.parent;
//    var next2   = elm2.nextElementSibling;
//
//    parent1.insertBefore(elm2, next1);
//    parent2.insertBefore(elm1, next2);
  }
//
  setupView() {
    var a = new Assortment(querySelector('.card-list'));
    a.addElements(querySelectorAll('.card'));

//    a.onDragEnd.listen((AssortmentEvent event) {
//      print('drag end enter ${event.enterElement}');
//      print('drag end from ${event.fromElement}');
//      print('drag end drag ${event.dragElement}');
//    });
    a.onDragEnter.listen((AssortmentEvent event) {
      print('drag enter enter ${event.enterElement.parent.parent.parent.getAttribute('data-column-id')}');
//      print('drag enter from ${event.fromElement}');
//      print('drag enter drag ${event.dragElement}');
    });
//    a.onDragStart.listen((AssortmentEvent event) {
//      print('drag start enter ${event.enterElement}');
//      print('drag start from ${event.fromElement}');
//      print('drag start drag ${event.dragElement}');
//    });
  }

}
