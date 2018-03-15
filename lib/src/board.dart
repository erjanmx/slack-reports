import 'card.dart';
import 'column.dart';

class Board {
  Column projectColumn = new Column(0, 'Projects');
  List<Card> projects = [];

  List<Column> columns = [];
  List<Card> cards = [];

  bool eveningReport = false;

  Map<int, String> statuses = {
    1: 'НЕ СДЕЛАНО',
    2: 'В ПРОЦЕССЕ',
    3: 'СДЕЛАНО',
  };

  String getCard(Card card) {
    if (!this.eveningReport) {
      if (card.columnId == 3) {
        return '';
      }

      return '${card.title}\n';
    }

    return '${card.title} - ${this.statuses[card.columnId]}\n';
  }


  String projectCards() {
    String output = '';

    this.projects.forEach((Card project) {

      List<Card> projectCards = this.cards.where((Card card) => (card.projectId == project.id && project.id != 0)).toList();

      if (projectCards.isNotEmpty) {
        output += '\n- ${project.title}\n';

        projectCards.forEach((Card card) {
          output += this.getCard(card);
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
        output += this.getCard(card);
      });
    }

    return output;
  }

  @override
  String toString() {
    this.cards.sort((a, b) => -a.columnId.compareTo(b.columnId));

    return (this.projectCards() + this.nonProjectCards()).trim();
  }
}
