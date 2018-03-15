
class Card {
  final int id;

  String title;
  int columnId;
  int order;
  int projectId;

  Card(this.id, this.title, this.columnId, this.order, [this.projectId]);
}
