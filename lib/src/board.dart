import 'card.dart';
import 'column.dart';

class Board {
  List<Column> columns = [];
  List<Card> cards = [];

  Map<int, String> statuses = {
    1: '',
    2: 'В ПРОЦЕССЕ',
    3: 'СДЕЛАНО',
  };

  @override
  String toString() {
    String output = '';

    this.cards.forEach((Card card) {
      output += card.title + ' - ' + this.statuses[card.columnId] + '\n';
    });

    return output;
  }
}
