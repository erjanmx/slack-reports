
class Column {
  final int id;
  String name;

  Column(this.id, this.name);

  bool isProject() => this.id == 0;
}
