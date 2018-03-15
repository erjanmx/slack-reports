import 'card.dart';
import 'column.dart';

class Board {
  Column projectColumn = new Column(0, 'Projects');
  List<Card> projects = [];

  List<Column> columns = [];
  List<Card> cards = [];

  Map<int, String> statuses = {
    1: '',
    2: 'В ПРОЦЕССЕ',
    3: 'СДЕЛАНО',
  };

  String projectCards() {
    String output = '';

    this.projects.forEach((Card project) {

      List<Card> projectCards = this.cards.where((Card card) => (card.projectId == project.id)).toList();

      if (projectCards.isNotEmpty) {
        output += '\n- ${project.title}\n';

        projectCards.forEach((Card card) {
          output += '${card.title} - ${this.statuses[card.columnId]}\n';
        });

      }
    });

    return output.trimLeft();
  }

  String nonProjectCards() {
    String output = '';

    List<Card> nonProjectCards = this.cards.where((Card card) => (card.projectId == 0)).toList();

    if (nonProjectCards.isNotEmpty) {
      output += '\n';

      nonProjectCards.forEach((Card card) {
        output += '${card.title} - ${this.statuses[card.columnId]}\n';
      });
    }

    return output;
  }

  @override
  String toString() {
    return (this.projectCards() + this.nonProjectCards()).trim();
  }
}
