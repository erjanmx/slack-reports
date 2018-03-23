
class ProjectCard {
  String id;
  String title;
  String color;
  int order;

  ProjectCard(this.id, this.title, this.order, this.color);

  Map toJson() {
    Map map = new Map();

    map["id"] = this.id;
    map["title"] = this.title;
    map["order"] = this.order;
    map["color"] = this.color;

    return map;
  }

  ProjectCard.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    order = json['order'];
    color = json['color'];
  }
}
