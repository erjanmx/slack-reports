import 'card.dart';
import 'column.dart';

class Board {
  List<Column> columns = [];
  List<Card> cards = [];

  @override
  String toString() {
    String output = '';
    this.columns.forEach((Column column) {
      output += column.name + '\n';

      this.cards.where((Card card) => (card.columnId == column.id)).toList().forEach((Card card) {
        output += card.title + '\n';
      });

      output += '\n';
    });

    return output;
  }
}
