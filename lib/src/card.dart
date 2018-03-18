
class Card {
  String id;

  String title;
  int columnId;
  int order;
  String projectId;

  Card(this.id, this.title, this.columnId, this.order, [this.projectId]);

  Map toJson() {
    Map map = new Map();

    map["id"] = this.id;
    map["title"] = this.title;
    map["order"] = this.order;
    map["columnId"] = this.columnId;
    map["projectId"] = this.projectId;

    return map;
  }

  Card.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    order = json['order'];
    columnId = json['columnId'];
    projectId = json['projectId'];
  }
}
